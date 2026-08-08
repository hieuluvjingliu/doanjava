package dao;

import model.HoaDon;
import model.HoaDonChiTiet;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.CartItem;

/**
 * DAO thao tác bảng {@code hoa_don} và {@code hoa_don_chi_tiet}.
 */
public class HoaDonDAO extends AbstractDAO {

    public int checkoutTransaction(HoaDon order, List<CartItem> cartItems) {
        String insertHoaDonSql = "INSERT INTO hoa_don (user_id, receiver_name, receiver_phone, receiver_address, note, total_amount, payment_method, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String insertChiTietSql = "INSERT INTO hoa_don_chi_tiet (invoice_id, variant_id, product_name, color_name, size_name, product_image, price_at_purchase, quantity, line_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateStockSql = "UPDATE san_pham_chi_tiet SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                int invoiceId = -1;
                // 1. Tạo hóa đơn
                try (PreparedStatement psHoaDon = con.prepareStatement(insertHoaDonSql, Statement.RETURN_GENERATED_KEYS)) {
                    psHoaDon.setInt(1, order.getUserId());
                    psHoaDon.setString(2, order.getReceiverName());
                    psHoaDon.setString(3, order.getReceiverPhone());
                    psHoaDon.setString(4, order.getReceiverAddress());
                    psHoaDon.setString(5, order.getNote());
                    psHoaDon.setBigDecimal(6, order.getTotalAmount());
                    psHoaDon.setString(7, order.getPaymentMethod());
                    psHoaDon.setString(8, order.getOrderStatus());
                    
                    if (psHoaDon.executeUpdate() > 0) {
                        try (ResultSet rs = psHoaDon.getGeneratedKeys()) {
                            if (rs.next()) invoiceId = rs.getInt(1);
                        }
                    }
                }

                if (invoiceId <= 0) {
                    con.rollback();
                    return -1;
                }

                // 2. Tạo chi tiết hóa đơn & 3. Trừ tồn kho
                try (PreparedStatement psChiTiet = con.prepareStatement(insertChiTietSql);
                     PreparedStatement psStock = con.prepareStatement(updateStockSql)) {
                    
                    for (CartItem item : cartItems) {
                        // Thêm chi tiết
                        psChiTiet.setInt(1, invoiceId);
                        psChiTiet.setInt(2, item.getVariantId());
                        psChiTiet.setString(3, item.getProductName());
                        psChiTiet.setString(4, item.getColorName());
                        psChiTiet.setString(5, item.getSizeName());
                        psChiTiet.setString(6, item.getProductImage());
                        psChiTiet.setBigDecimal(7, item.getPrice());
                        psChiTiet.setInt(8, item.getQuantity());
                        psChiTiet.setBigDecimal(9, item.getTotal());
                        psChiTiet.addBatch();

                        // Trừ tồn kho
                        psStock.setInt(1, item.getQuantity());
                        psStock.setInt(2, item.getVariantId());
                        psStock.setInt(3, item.getQuantity());
                        psStock.addBatch();
                    }
                    
                    psChiTiet.executeBatch();
                    int[] stockResults = psStock.executeBatch();
                    
                    // Kiểm tra xem có sản phẩm nào bị lỗi trừ tồn kho không (Hết hàng)
                    for (int res : stockResults) {
                        if (res == 0) {
                            con.rollback();
                            return -2; // Báo lỗi hết hàng
                        }
                    }
                }

                con.commit();
                return invoiceId;
                
            } catch (SQLException ex) {
                con.rollback();
                log.log(java.util.logging.Level.SEVERE, "Rollback checkoutTransaction", ex);
                return -1;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logSqlError("checkoutTransaction", e);
            return -1;
        }
    }

    public int createHoaDon(HoaDon hoaDon) {
        String sql = "INSERT INTO hoa_don (user_id, receiver_name, receiver_phone, receiver_address, note, total_amount, payment_method, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, hoaDon.getUserId());
            ps.setString(2, hoaDon.getReceiverName());
            ps.setString(3, hoaDon.getReceiverPhone());
            ps.setString(4, hoaDon.getReceiverAddress());
            ps.setString(5, hoaDon.getNote());
            ps.setBigDecimal(6, hoaDon.getTotalAmount());
            ps.setString(7, hoaDon.getPaymentMethod());
            ps.setString(8, hoaDon.getOrderStatus());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logSqlError("createHoaDon", e);
        }
        return -1;
    }

    public boolean createHoaDonChiTiet(HoaDonChiTiet chiTiet) {
        String sql = "INSERT INTO hoa_don_chi_tiet (invoice_id, variant_id, product_name, color_name, size_name, product_image, price_at_purchase, quantity, line_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, chiTiet.getInvoiceId());
            ps.setInt(2, chiTiet.getVariantId());
            ps.setString(3, chiTiet.getProductName());
            ps.setString(4, chiTiet.getColorName());
            ps.setString(5, chiTiet.getSizeName());
            ps.setString(6, chiTiet.getProductImage());
            ps.setBigDecimal(7, chiTiet.getPriceAtPurchase());
            ps.setInt(8, chiTiet.getQuantity());
            ps.setBigDecimal(9, chiTiet.getLineTotal());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("createHoaDonChiTiet", e);
        }
        return false;
    }

    public boolean updateStock(int variantId, int quantityReduce) {
        String sql = "UPDATE san_pham_chi_tiet SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantityReduce);
            ps.setInt(2, variantId);
            ps.setInt(3, quantityReduce);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("updateStock(variantId=" + variantId + ")", e);
        }
        return false;
    }

    public List<HoaDon> getByUserId(int userId) {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logSqlError("getByUserId(" + userId + ")", e);
        }
        return list;
    }

    public List<HoaDon> getAll() {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don ORDER BY created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logSqlError("getAll", e);
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM hoa_don";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logSqlError("countAll", e);
        }
        return 0;
    }

    public List<HoaDon> getByPage(int offset, int limit) {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            logSqlError("getByPage", e);
        }
        return list;
    }

    public HoaDon getById(int id) {
        String sql = "SELECT * FROM hoa_don WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            logSqlError("getById(" + id + ")", e);
        }
        return null;
    }

    public List<HoaDonChiTiet> getChiTietByInvoiceId(int invoiceId) {
        List<HoaDonChiTiet> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don_chi_tiet WHERE invoice_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HoaDonChiTiet ct = new HoaDonChiTiet();
                ct.setId(rs.getInt("id"));
                ct.setInvoiceId(rs.getInt("invoice_id"));
                ct.setVariantId(rs.getInt("variant_id"));
                ct.setProductName(rs.getString("product_name"));
                ct.setColorName(rs.getString("color_name"));
                ct.setSizeName(rs.getString("size_name"));
                ct.setProductImage(rs.getString("product_image"));
                ct.setPriceAtPurchase(rs.getBigDecimal("price_at_purchase"));
                ct.setQuantity(rs.getInt("quantity"));
                ct.setLineTotal(rs.getBigDecimal("line_total"));
                list.add(ct);
            }
        } catch (SQLException e) {
            logSqlError("getChiTietByInvoiceId(" + invoiceId + ")", e);
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE hoa_don SET order_status = ?, updated_at = GETDATE() WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("updateStatus(id=" + id + ")", e);
        }
        return false;
    }

    private HoaDon mapRow(ResultSet rs) throws SQLException {
        HoaDon hd = new HoaDon();
        hd.setId(rs.getInt("id"));
        hd.setUserId(rs.getInt("user_id"));
        hd.setReceiverName(rs.getString("receiver_name"));
        hd.setReceiverPhone(rs.getString("receiver_phone"));
        hd.setReceiverAddress(rs.getString("receiver_address"));
        hd.setNote(rs.getString("note"));
        hd.setTotalAmount(rs.getBigDecimal("total_amount"));
        hd.setPaymentMethod(rs.getString("payment_method"));
        hd.setOrderStatus(rs.getString("order_status"));
        // Bắt null để tránh NPE khi cột created_at / updated_at cho phép NULL
        java.sql.Timestamp tsCreated = rs.getTimestamp("created_at");
        hd.setCreatedAt(tsCreated != null ? tsCreated.toLocalDateTime() : null);
        java.sql.Timestamp tsUpdated = rs.getTimestamp("updated_at");
        hd.setUpdatedAt(tsUpdated != null ? tsUpdated.toLocalDateTime() : null);
        return hd;
    }
}
