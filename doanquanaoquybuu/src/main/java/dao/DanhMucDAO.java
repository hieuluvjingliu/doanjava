package dao;

import model.DanhMuc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO thao tác bảng {@code danh_muc}.
 */
public class DanhMucDAO extends AbstractDAO {

    public List<DanhMuc> getAll() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM danh_muc";

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

    public DanhMuc getById(int id) {
        String sql = "SELECT * FROM danh_muc WHERE id = ?";
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

    public boolean insert(DanhMuc dm) {
        String sql = "INSERT INTO danh_muc(name, description, status) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dm.getName());
            ps.setString(2, dm.getDescription());
            ps.setString(3, dm.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("insert", e);
        }
        return false;
    }

    public boolean update(DanhMuc dm) {
        String sql = "UPDATE danh_muc SET name = ?, description = ?, status = ? WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dm.getName());
            ps.setString(2, dm.getDescription());
            ps.setString(3, dm.getStatus());
            ps.setInt(4, dm.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("update(id=" + dm.getId() + ")", e);
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM danh_muc WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logSqlError("delete(id=" + id + ")", e);
        }
        return false;
    }

    private static DanhMuc mapRow(ResultSet rs) throws SQLException {
        DanhMuc dm = new DanhMuc();
        dm.setId(rs.getInt("id"));
        dm.setName(rs.getString("name"));
        dm.setDescription(rs.getString("description"));
        dm.setStatus(rs.getString("status"));
        dm.setCreatedAt(rs.getTimestamp("created_at"));
        return dm;
    }
}
