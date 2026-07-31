package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Tiện ích mở kết nối JDBC đến SQL Server.
 *
 * <p>Class giữ một {@code Connection} tĩnh dùng làm pool tối giản cho môi trường học tập.
 * Trong môi trường production, nên dùng {@code DataSource} hoặc connection pool chuẩn
 * (HikariCP, Tomcat JDBC Pool, …).</p>
 *
 * <p>Quy ước sử dụng:
 * <ul>
 *   <li>{@link #getConnection()} — trả về connection đang mở (tự mở lại nếu connection cũ đã đóng).</li>
 *   <li>{@link #getNewConnection()} — trả về một connection mới hoàn toàn (an toàn cho multi-thread).</li>
 * </ul>
 * </p>
 */
public final class ConnectDB {

    private static final Logger LOGGER = Logger.getLogger(ConnectDB.class.getName());

    private static final String DB_URL =
              "jdbc:sqlserver://localhost:1433;"
            + "databaseName=QL_QUYBUU;"
            + "user=sa;password=123456;"
            + "encrypt=true;trustServerCertificate=true";

    private static volatile Connection sharedConnection;

    private ConnectDB() {}

    /** Alias tương thích ngược — trả về connection chia sẻ. */
    public static Connection getConnect() {
        return getConnection();
    }

    /**
     * Trả về connection sẵn sàng dùng. Tự mở lại nếu connection trước đó đã bị đóng
     * (ví dụ: do DAO trước đặt connection vào try-with-resources). Đảm bảo an toàn
     * cho multi-thread nhờ double-checked locking.
     */
    public static Connection getConnection() {
        Connection local = sharedConnection;
        if (local == null || isClosedQuietly(local)) {
            synchronized (ConnectDB.class) {
                local = sharedConnection;
                if (local == null || isClosedQuietly(local)) {
                    sharedConnection = openConnection();
                    local = sharedConnection;
                }
            }
        }
        return local;
    }

    /**
     * Gọi {@link Connection#isClosed()} mà không propagate {@link SQLException}.
     * Trả về {@code true} nếu connection không xác định được trạng thái (coi như đã đóng).
     */
    private static boolean isClosedQuietly(Connection c) {
        try {
            return c.isClosed();
        } catch (SQLException e) {
            return true;
        }
    }

    /**
     * Luôn tạo một connection mới. Bắt buộc phải đóng (try-with-resources) sau khi sử dụng.
     */
    public static Connection getNewConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(DB_URL);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Không tìm thấy JDBC driver", e);
            throw new SQLException("JDBC driver not found", e);
        }
    }

    private static Connection openConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(DB_URL);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Không tìm thấy thư viện JDBC", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kết nối SQL Server", e);
        }
        return null;
    }

    public static void main(String[] args) {
        try (Connection c = getNewConnection()) {
            System.out.println("Kết nối thành công: " + (c != null && !c.isClosed()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Kết nối thất bại", e);
        }
    }
}
