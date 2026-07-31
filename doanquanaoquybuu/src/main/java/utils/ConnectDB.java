package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
    public static Connection con = null;

    public static Connection getConnect() {
        return getConnection();
    }

    public static Connection getConnection() {
        String strDbUrl = "jdbc:sqlserver://localhost:1433;"
                + "databaseName=QL_QUYBUU;"
                + "user=sa;password=123456;"
                + "encrypt=true;trustServerCertificate=true";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(strDbUrl);
        } catch (ClassNotFoundException e) {
            System.err.println("LỖI: Không tìm thấy thư viện JDBC: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("LỖI SQL: " + e.getMessage());
        }

        return con;
    }

    public static void main(String[] args) {
        ConnectDB.getConnect();
    }
}
