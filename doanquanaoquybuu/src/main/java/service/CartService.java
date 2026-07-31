package service;

import jakarta.servlet.http.HttpSession;
import model.CartItem;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CartService {

    public static final String CART_SESSION_KEY = "CART";

    @SuppressWarnings("unchecked")
    public static List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    public static void addToCart(HttpSession session, CartItem item) {
        List<CartItem> cart = getCart(session);
        boolean found = false;

        for (CartItem ci : cart) {
            if (ci.getProductId() == item.getProductId()) {
                ci.setQuantity(ci.getQuantity() + item.getQuantity());
                found = true;
                break;
            }
        }

        if (!found) {
            cart.add(item);
        }

        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public static void updateQuantity(HttpSession session, int productId, int quantity) {
        List<CartItem> cart = getCart(session);
        for (CartItem ci : cart) {
            if (ci.getProductId() == productId) {
                if (quantity <= 0) {
                    cart.remove(ci);
                } else {
                    ci.setQuantity(quantity);
                }
                break;
            }
        }
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public static void removeFromCart(HttpSession session, int productId) {
        List<CartItem> cart = getCart(session);
        cart.removeIf(ci -> ci.getProductId() == productId);
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public static void clearCart(HttpSession session) {
        session.removeAttribute(CART_SESSION_KEY);
    }

    public static int getCartCount(HttpSession session) {
        List<CartItem> cart = getCart(session);
        return cart.stream().mapToInt(CartItem::getQuantity).sum();
    }

    public static BigDecimal getCartTotal(HttpSession session) {
        List<CartItem> cart = getCart(session);
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem ci : cart) {
            total = total.add(ci.getTotal());
        }
        return total;
    }
}
