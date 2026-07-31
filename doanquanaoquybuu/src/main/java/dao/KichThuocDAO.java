package dao;

import model.KichThuoc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO thao tác bảng {@code kich_thuoc}.
 */
public class KichThuocDAO extends AbstractDAO {

    public List<KichThuoc> getAll() {
        List<KichThuoc> list = new ArrayList<>();
        String sql = "SELECT * FROM kich_thuoc ORDER BY sort_order ASC";
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

    public boolean insert(KichThuoc kt) {
        String sql = "INSERT INTO kich_thuoc(name, sort_order, status) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, kt.getName());
            ps.setInt(2, kt.getSortOrder());
            ps.setString(3, kt.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("insert", e);
        }
        return false;
    }

    public boolean update(KichThuoc kt) {
        String sql = "UPDATE kich_thuoc SET name = ?, sort_order = ?, status = ? WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, kt.getName());
            ps.setInt(2, kt.getSortOrder());
            ps.setString(3, kt.getStatus());
            ps.setInt(4, kt.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("update(id=" + kt.getId() + ")", e);
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM kich_thuoc WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("delete(id=" + id + ")", e);
        }
        return false;
    }

    public KichThuoc getByName(String name) {
        String sql = "SELECT * FROM kich_thuoc WHERE LOWER(LTRIM(RTRIM(name))) = LOWER(LTRIM(RTRIM(?))) AND status = 'ACTIVE'";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            logSqlError("getByName(" + name + ")", e);
        }
        return null;
    }

    public KichThuoc getById(int id) {
        String sql = "SELECT * FROM kich_thuoc WHERE id = ?";
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

    private static KichThuoc mapRow(ResultSet rs) throws SQLException {
        return new KichThuoc(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getInt("sort_order"),
                rs.getString("status")
        );
    }
}
