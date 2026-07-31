package dao;

import model.MauSac;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO thao tác bảng {@code mau_sac}.
 */
public class MauSacDAO extends AbstractDAO {

    public List<MauSac> getAll() {
        List<MauSac> list = new ArrayList<>();
        String sql = "SELECT * FROM mau_sac";
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

    public boolean insert(MauSac ms) {
        String sql = "INSERT INTO mau_sac(name, status) VALUES (?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ms.getName());
            ps.setString(2, ms.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("insert", e);
        }
        return false;
    }

    public boolean update(MauSac ms) {
        String sql = "UPDATE mau_sac SET name = ?, status = ? WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ms.getName());
            ps.setString(2, ms.getStatus());
            ps.setInt(3, ms.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("update(id=" + ms.getId() + ")", e);
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM mau_sac WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("delete(id=" + id + ")", e);
        }
        return false;
    }

    public MauSac getById(int id) {
        String sql = "SELECT * FROM mau_sac WHERE id = ?";
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

    private static MauSac mapRow(ResultSet rs) throws SQLException {
        return new MauSac(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("status")
        );
    }
}
