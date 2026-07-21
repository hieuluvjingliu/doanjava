package dao;

import model.SanPhamChiTiet;
import utils.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SanPhamChiTietDAO {

    public List<SanPhamChiTiet> getByProductId(int productId) {
        List<SanPhamChiTiet> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham_chi_tiet WHERE product_id = ?";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Double price = rs.getObject("price") != null ? rs.getDouble("price") : null;
                    list.add(new SanPhamChiTiet(
                            rs.getInt("id"),
                            rs.getInt("product_id"),
                            rs.getInt("color_id"),
                            rs.getInt("size_id"),
                            rs.getString("sku"),
                            price,
                            rs.getInt("quantity"),
                            rs.getString("image"),
                            rs.getString("status")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(SanPhamChiTiet spct) {
        String sql = "INSERT INTO san_pham_chi_tiet(product_id, color_id, size_id, sku, price, quantity, image, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, spct.getProductId());
            ps.setInt(2, spct.getColorId());
            ps.setInt(3, spct.getSizeId());
            ps.setString(4, spct.getSku());
            if (spct.getPrice() != null) {
                ps.setDouble(5, spct.getPrice());
            } else {
                ps.setNull(5, java.sql.Types.DECIMAL);
            }
            ps.setInt(6, spct.getQuantity());
            ps.setString(7, spct.getImage());
            ps.setString(8, spct.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(SanPhamChiTiet spct) {
        String sql = "UPDATE san_pham_chi_tiet SET color_id=?, size_id=?, sku=?, price=?, quantity=?, image=?, status=? WHERE id=?";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, spct.getColorId());
            ps.setInt(2, spct.getSizeId());
            ps.setString(3, spct.getSku());
            if (spct.getPrice() != null) {
                ps.setDouble(4, spct.getPrice());
            } else {
                ps.setNull(4, java.sql.Types.DECIMAL);
            }
            ps.setInt(5, spct.getQuantity());
            ps.setString(6, spct.getImage());
            ps.setString(7, spct.getStatus());
            ps.setInt(8, spct.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
