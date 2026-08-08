package dao;

import utils.ConnectDB;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Lớp nền tảng cho tất cả DAO: cung cấp helper lấy {@link java.sql.Connection}
 * an toàn và logging chuẩn thông qua {@link java.util.logging.Logger}.
 *
 * <p>Mỗi lần gọi {@link #getConnection()} sẽ trả về một connection MỚI hoàn toàn.
 * Việc dùng connection chia sẻ (static) trước đây gây ra lỗi
 * "The connection is closed" khi một DAO đóng connection trước khi DAO khác
 * kịp dùng (race condition). Hãy luôn dùng try-with-resources khi sử dụng.</p>
 */
public abstract class AbstractDAO {

    protected final Logger log = Logger.getLogger(getClass().getName());

    /**
     * Luôn trả về một connection MỚI. Caller BẮT BUỘC phải đóng sau khi dùng
     * (khuyến nghị dùng try-with-resources để tránh leak).
     */
    protected Connection getConnection() throws SQLException {
        return ConnectDB.getNewConnection();
    }

    /** Alias — mở connection mới hoàn toàn. */
    protected Connection getNewConnection() throws SQLException {
        return ConnectDB.getNewConnection();
    }

    /** Log lỗi SQL chuẩn hoá cho mọi DAO. */
    protected void logSqlError(String operation, SQLException e) {
        log.log(Level.SEVERE, "Lỗi SQL khi " + operation, e);
    }
}
