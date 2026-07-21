package dao;

import model.KichThuoc;
import utils.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class KichThuocDAO {

    public List<KichThuoc> getAll() {
        List<KichThuoc> list = new ArrayList<>();
        String sql = "SELECT * FROM kich_thuoc ORDER BY sort_order ASC";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new KichThuoc(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("sort_order"),
                        rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(KichThuoc kt) {
        String sql = "INSERT INTO kich_thuoc(name, sort_order, status) VALUES (?, ?, ?)";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, kt.getName());
            ps.setInt(2, kt.getSortOrder());
            ps.setString(3, kt.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(KichThuoc kt) {
        String sql = "UPDATE kich_thuoc SET name = ?, sort_order = ?, status = ? WHERE id = ?";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, kt.getName());
            ps.setInt(2, kt.getSortOrder());
            ps.setString(3, kt.getStatus());
            ps.setInt(4, kt.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM kich_thuoc WHERE id = ?";
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
