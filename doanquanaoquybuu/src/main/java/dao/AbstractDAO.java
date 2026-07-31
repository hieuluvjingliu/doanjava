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
 * <p>Các DAO con sử dụng {@link #getConnection()} để có connection chia sẻ
 * (tương thích ngược) hoặc {@link #getNewConnection()} nếu cần connection riêng.</p>
 */
public abstract class AbstractDAO {

    protected final Logger log = Logger.getLogger(getClass().getName());

    /** Trả về connection chia sẻ từ {@link ConnectDB#getConnection()}. */
    protected Connection getConnection() {
        return ConnectDB.getConnection();
    }

    /** Mở connection mới hoàn toàn (cho code mới / transaction riêng). */
    protected Connection getNewConnection() throws SQLException {
        return ConnectDB.getNewConnection();
    }

    /** Log lỗi SQL chuẩn hoá cho mọi DAO. */
    protected void logSqlError(String operation, SQLException e) {
        log.log(Level.SEVERE, "Lỗi SQL khi " + operation, e);
    }
}
