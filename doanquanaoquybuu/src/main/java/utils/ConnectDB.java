package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
    public static Connection con = null;

    public static Connection getConnect() {
        // Thay tên database, tài khoản và mật khẩu theo máy của nhóm.
        String strDbUrl = "jdbc:sqlserver://localhost:1433;"
                + "databaseName=QL_QUYBUU;"
                + "user=sa;password=123456;"
                + "encrypt=true;trustServerCertificate=true";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(strDbUrl);
            System.out.println("Kết nối thành công");
        } catch (ClassNotFoundException e) {
            System.err.println("LỖI: Không tìm thấy thư viện JDBC (Thiếu file .jar): " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("LỖI SQL: Sai tên đăng nhập/mật khẩu, sai tên DB, hoặc chưa bật TCP/IP: " + e.getMessage());
            e.printStackTrace();
        }

        return con;
    }

    public static void main(String[] args) {
        ConnectDB.getConnect();
    }
}
