package dao;

import model.SanPham;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO thao tác bảng {@code san_pham}.
 */
public class SanPhamDAO extends AbstractDAO {

    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        // Sắp xếp theo id DESC để sản phẩm mới thêm luôn nằm ở đầu danh sách
        // Lọc INACTIVE (soft delete) cho user-facing
        String sql = "SELECT * FROM san_pham WHERE status = 'ACTIVE' ORDER BY id DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logSqlError("getAll", e);
        }
        return list;
    }

    /**
     * Lấy N sản phẩm mới nhất (theo id DESC).
     * Dùng cho trang chủ / banner "Sản phẩm mới".
     */
    public List<SanPham> getNewest(int limit) {
        List<SanPham> list = new ArrayList<>();
        if (limit <= 0) return list;
        // TOP không nhận được tham số '?' trong SQL Server, nội suy trực tiếp
        // giá trị đã được validate (limit > 0).
        String sql = "SELECT TOP " + limit + " * FROM san_pham WHERE status = 'ACTIVE' ORDER BY id DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logSqlError("getNewest(" + limit + ")", e);
        }
        return list;
    }

    public List<SanPham> getByCategoryId(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham WHERE category_id = ? AND status = 'ACTIVE'";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logSqlError("getByCategoryId(" + categoryId + ")", e);
        }
        return list;
    }

    public List<SanPham> searchByKeyword(String keyword) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham WHERE status = 'ACTIVE' AND (name LIKE ? OR description LIKE ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logSqlError("searchByKeyword(" + keyword + ")", e);
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM san_pham WHERE status = 'ACTIVE'";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logSqlError("countAll", e);
        }
        return 0;
    }

    public List<SanPham> getByPage(int offset, int limit) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham WHERE status = 'ACTIVE' ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            logSqlError("getByPage", e);
        }
        return list;
    }

    public SanPham getById(int id) {
        String sql = "SELECT * FROM san_pham WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logSqlError("getById(" + id + ")", e);
        }
        return null;
    }

    public boolean insert(SanPham sp) {
        String sql = "INSERT INTO san_pham(category_id, name, description, base_price, image, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sp.getCategoryId());
            ps.setString(2, sp.getName());
            ps.setString(3, sp.getDescription());
            // Chuyển double -> BigDecimal với scale = 2 (khớp NUMERIC(p,2) trong DB)
            // tránh lỗi "Arithmetic overflow converting float to numeric" do double
            // có nhiều chữ số thập phân hơn scale cho phép.
            ps.setBigDecimal(4, toMoney(sp.getBasePrice()));
            ps.setString(5, sp.getImage());
            ps.setString(6, sp.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("insert", e);
        }
        return false;
    }

    public boolean update(SanPham sp) {
        String sql = "UPDATE san_pham SET category_id=?, name=?, description=?, base_price=?, image=?, status=? WHERE id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sp.getCategoryId());
            ps.setString(2, sp.getName());
            ps.setString(3, sp.getDescription());
            ps.setBigDecimal(4, toMoney(sp.getBasePrice()));
            ps.setString(5, sp.getImage());
            ps.setString(6, sp.getStatus());
            ps.setInt(7, sp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("update(id=" + sp.getId() + ")", e);
        }
        return false;
    }

    /**
     * Chuẩn hóa giá tiền về BigDecimal scale 2, HALF_UP.
     * Tránh lỗi "Arithmetic overflow converting float to numeric"
     * khi double có quá nhiều chữ số thập phân so với scale của NUMERIC(p,s).
     */
    private static BigDecimal toMoney(double value) {
        if (Double.isNaN(value) || Double.isInfinite(value)) {
            return BigDecimal.ZERO;
        }
        return BigDecimal.valueOf(value).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Soft delete: đánh dấu sản phẩm là INACTIVE thay vì xóa thật.
     * Tránh triệt để mọi lỗi FK cascade (cart_items, hoa_don_chi_tiet, ...).
     * Giữ nguyên lịch sử đơn hàng đã phát sinh.
     *
     * Đồng thời ẩn luôn các biến thể (san_pham_chi_tiet) để user không thêm
     * vào giỏ được nữa.
     */
    public boolean delete(int id) {
        String sqlDeactivateVariants = "UPDATE san_pham_chi_tiet SET status = 'INACTIVE' WHERE product_id = ?";
        String sqlDeactivateProduct = "UPDATE san_pham SET status = 'INACTIVE' WHERE id = ?";
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(sqlDeactivateVariants)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                int affected = 0;
                try (PreparedStatement ps = con.prepareStatement(sqlDeactivateProduct)) {
                    ps.setInt(1, id);
                    affected = ps.executeUpdate();
                }
                con.commit();
                return affected > 0;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logSqlError("delete(id=" + id + ")", e);
        }
        return false;
    }

    /** Reactivate: khôi phục sản phẩm đã soft delete. */
    public boolean restore(int id) {
        String sql = "UPDATE san_pham SET status = 'ACTIVE' WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("restore(id=" + id + ")", e);
        }
        return false;
    }

    private static SanPham mapRow(ResultSet rs) throws SQLException {
        return new SanPham(
                rs.getInt("id"),
                rs.getInt("category_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getDouble("base_price"),
                rs.getString("image"),
                rs.getString("status"),
                rs.getTimestamp("created_at")
        );
    }
}
