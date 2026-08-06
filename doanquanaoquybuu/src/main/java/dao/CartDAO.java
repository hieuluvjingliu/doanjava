package dao;

import model.CartItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO thao tác bảng giỏ hàng {@code carts} / {@code cart_items}.
 */
public class CartDAO extends AbstractDAO {

    public List<CartItem> getCartByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT product_id, variant_id, product_name, color_name, size_name, product_image, price, quantity " +
                     "FROM cart_items WHERE cart_user_id = ? " +
                     "ORDER BY product_name";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new CartItem(
                            rs.getInt("product_id"),
                            rs.getInt("variant_id"),
                            rs.getString("product_name"),
                            rs.getString("color_name"),
                            rs.getString("size_name"),
                            rs.getString("product_image"),
                            rs.getBigDecimal("price"),
                            rs.getInt("quantity")
                    ));
                }
            }
        } catch (SQLException e) {
            logSqlError("getCartByUserId(userId=" + userId + ")", e);
        }
        return list;
    }

    public void saveCart(int userId, List<CartItem> cart) {
        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                upsertCartRow(con, userId);

                try (PreparedStatement del = con.prepareStatement(
                        "DELETE FROM cart_items WHERE cart_user_id = ?")) {
                    del.setInt(1, userId);
                    del.executeUpdate();
                }

                if (!cart.isEmpty()) {
                    try (PreparedStatement ins = con.prepareStatement(
                            "INSERT INTO cart_items(cart_user_id, product_id, variant_id, product_name, color_name, size_name, product_image, price, quantity) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")) {
                        for (CartItem ci : cart) {
                            ins.setInt(1, userId);
                            ins.setInt(2, ci.getProductId());
                            ins.setInt(3, ci.getVariantId());
                            ins.setString(4, ci.getProductName());
                            ins.setString(5, ci.getColorName());
                            ins.setString(6, ci.getSizeName());
                            ins.setString(7, ci.getProductImage());
                            ins.setBigDecimal(8, ci.getPrice());
                            ins.setInt(9, ci.getQuantity());
                            ins.addBatch();
                        }
                        ins.executeBatch();
                    }
                }
                con.commit();
            } catch (SQLException ex) {
                con.rollback();
                log.log(java.util.logging.Level.SEVERE, "Rollback saveCart", ex);
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logSqlError("saveCart(userId=" + userId + ")", e);
        }
    }

    public void clearCartByUserId(int userId) {
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "DELETE FROM cart_items WHERE cart_user_id = ?")) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            logSqlError("clearCartByUserId(userId=" + userId + ")", e);
        }
    }

    private void upsertCartRow(Connection con, int userId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "IF EXISTS (SELECT 1 FROM carts WHERE user_id = ?) " +
                "    UPDATE carts SET updated_at = GETDATE() WHERE user_id = ? " +
                "ELSE " +
                "    INSERT INTO carts(user_id) VALUES (?)")) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.executeUpdate();
        }
    }
}
