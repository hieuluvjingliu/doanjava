package dao;

import model.HoaDon;
import model.HoaDonChiTiet;
import model.CartItem;
import utils.ConnectDB;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class HoaDonDAO {

    public int createHoaDon(HoaDon hoaDon) {
        String sql = "INSERT INTO hoa_don (user_id, receiver_name, receiver_phone, receiver_address, note, total_amount, payment_method, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConnectDB.getConnection();
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
            e.printStackTrace();
        }
        return -1;
    }

    public boolean createHoaDonChiTiet(HoaDonChiTiet chiTiet) {
        String sql = "INSERT INTO hoa_don_chi_tiet (invoice_id, variant_id, product_name, color_name, size_name, product_image, price_at_purchase, quantity, line_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConnectDB.getConnection();
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
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStock(int variantId, int quantityReduce) {
        String sql = "UPDATE san_pham_chi_tiet SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";
        
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantityReduce);
            ps.setInt(2, variantId);
            ps.setInt(3, quantityReduce);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<HoaDon> getByUserId(int userId) {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                HoaDon hd = mapResultSet(rs);
                list.add(hd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<HoaDon> getAll() {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don ORDER BY created_at DESC";
        
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                HoaDon hd = mapResultSet(rs);
                list.add(hd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM hoa_don";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<HoaDon> getByPage(int offset, int limit) {
        List<HoaDon> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HoaDon hd = mapResultSet(rs);
                list.add(hd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public HoaDon getById(int id) {
        String sql = "SELECT * FROM hoa_don WHERE id = ?";
        
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<HoaDonChiTiet> getChiTietByInvoiceId(int invoiceId) {
        List<HoaDonChiTiet> list = new ArrayList<>();
        String sql = "SELECT * FROM hoa_don_chi_tiet WHERE invoice_id = ?";
        
        try (Connection conn = ConnectDB.getConnection();
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
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE hoa_don SET order_status = ?, updated_at = GETDATE() WHERE id = ?";
        
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private HoaDon mapResultSet(ResultSet rs) throws SQLException {
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
        hd.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        hd.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return hd;
    }
}
