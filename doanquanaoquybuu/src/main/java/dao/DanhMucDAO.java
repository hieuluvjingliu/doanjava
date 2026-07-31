package dao;

import model.DanhMuc;
import utils.ConnectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DanhMucDAO {

    public List<DanhMuc> getAll() {
        List<DanhMuc> list = new ArrayList<>();
        String sql = "SELECT * FROM danh_muc";
        
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                DanhMuc dm = new DanhMuc();
                dm.setId(rs.getInt("id"));
                dm.setName(rs.getString("name"));
                dm.setDescription(rs.getString("description"));
                dm.setStatus(rs.getString("status"));
                dm.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(dm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public DanhMuc getById(int id) {
        String sql = "SELECT * FROM danh_muc WHERE id = ?";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DanhMuc dm = new DanhMuc();
                    dm.setId(rs.getInt("id"));
                    dm.setName(rs.getString("name"));
                    dm.setDescription(rs.getString("description"));
                    dm.setStatus(rs.getString("status"));
                    dm.setCreatedAt(rs.getTimestamp("created_at"));
                    return dm;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(DanhMuc dm) {
        String sql = "INSERT INTO danh_muc(name, description, status) VALUES (?, ?, ?)";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, dm.getName());
            ps.setString(2, dm.getDescription());
            ps.setString(3, dm.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(DanhMuc dm) {
        String sql = "UPDATE danh_muc SET name = ?, description = ?, status = ? WHERE id = ?";
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, dm.getName());
            ps.setString(2, dm.getDescription());
            ps.setString(3, dm.getStatus());
            ps.setInt(4, dm.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM danh_muc WHERE id = ?";
        // #region agent log
        boolean logResult = false;
        try {
            java.io.FileWriter fw = new java.io.FileWriter("d:\\Spring\\debug-386ec2.log", true);
            java.io.PrintWriter pw = new java.io.PrintWriter(fw);
            pw.println("{\"sessionId\":\"386ec2\",\"id\":\"log_" + System.currentTimeMillis() + "\",\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"DanhMucDAO.java:71\",\"message\":\"DanhMucDAO.delete called\",\"data\":{\"id\":" + id + "},\"runId\":\"run2\",\"hypothesisId\":\"H4\"}");
            pw.close();
            fw.close();
        } catch (Exception e) {}
        // #endregion
        try (Connection con = ConnectDB.getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            logResult = ps.executeUpdate() > 0;
            // #region agent log
            try {
                java.io.FileWriter fw = new java.io.FileWriter("d:\\Spring\\debug-386ec2.log", true);
                java.io.PrintWriter pw = new java.io.PrintWriter(fw);
                pw.println("{\"sessionId\":\"386ec2\",\"id\":\"log_" + System.currentTimeMillis() + "\",\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"DanhMucDAO.java:71\",\"message\":\"DanhMucDAO.delete result\",\"data\":{\"id\":" + id + ",\"rowsAffected\":" + (logResult ? 1 : 0) + "},\"runId\":\"run2\",\"hypothesisId\":\"H4\"}");
                pw.close();
                fw.close();
            } catch (Exception e) {}
            // #endregion
            return logResult;
        } catch (SQLException e) {
            // #region agent log
            try {
                java.io.FileWriter fw = new java.io.FileWriter("d:\\Spring\\debug-386ec2.log", true);
                java.io.PrintWriter pw = new java.io.PrintWriter(fw);
                pw.println("{\"sessionId\":\"386ec2\",\"id\":\"log_" + System.currentTimeMillis() + "\",\"timestamp\":" + System.currentTimeMillis() + ",\"location\":\"DanhMucDAO.java:71\",\"message\":\"DanhMucDAO.delete SQLException\",\"data\":{\"id\":" + id + ",\"sqlState\":\"" + e.getSQLState() + "\",\"errorCode\":" + e.getErrorCode() + ",\"message\":\"" + e.getMessage().replace("\"","'") + "\"},\"runId\":\"run2\",\"hypothesisId\":\"H4\"}");
                pw.close();
                fw.close();
            } catch (Exception ex) {}
            // #endregion
            e.printStackTrace();
        }
        return false;
    }
}
