package dao;

import model.SanPham;

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
        String sql = "SELECT * FROM san_pham";
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

    public List<SanPham> getByCategoryId(int categoryId) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham WHERE category_id = ?";
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
        String sql = "SELECT * FROM san_pham WHERE name LIKE ? OR description LIKE ?";
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
        String sql = "SELECT COUNT(*) FROM san_pham";
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
        String sql = "SELECT * FROM san_pham ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
            ps.setDouble(4, sp.getBasePrice());
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
            ps.setDouble(4, sp.getBasePrice());
            ps.setString(5, sp.getImage());
            ps.setString(6, sp.getStatus());
            ps.setInt(7, sp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("update(id=" + sp.getId() + ")", e);
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM san_pham WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("delete(id=" + id + ")", e);
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
