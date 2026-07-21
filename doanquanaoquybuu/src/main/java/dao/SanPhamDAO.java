package dao;

import model.SanPham;
import utils.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SanPhamDAO {

    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM san_pham";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("base_price"),
                        rs.getString("image"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(SanPham sp) {
        String sql = "INSERT INTO san_pham(category_id, name, description, base_price, image, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sp.getCategoryId());
            ps.setString(2, sp.getName());
            ps.setString(3, sp.getDescription());
            ps.setDouble(4, sp.getBasePrice());
            ps.setString(5, sp.getImage());
            ps.setString(6, sp.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(SanPham sp) {
        String sql = "UPDATE san_pham SET category_id=?, name=?, description=?, base_price=?, image=?, status=? WHERE id=?";
        try (Connection con = ConnectDB.getConnect();
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
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM san_pham WHERE id = ?";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
