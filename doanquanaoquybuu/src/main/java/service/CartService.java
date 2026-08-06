package service;

import dao.CartDAO;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.User;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CartService {

    public static final String CART_SESSION_KEY = "CART";
    public static final String USER_CART_LOADED_KEY = "USER_CART_LOADED";

    private static final CartDAO cartDAO = new CartDAO();

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
            if (ci.getVariantId() == item.getVariantId()) {
                ci.setQuantity(ci.getQuantity() + item.getQuantity());
                found = true;
                break;
            }
        }
        if (!found) {
            cart.add(item);
        }
        session.setAttribute(CART_SESSION_KEY, cart);
        persistIfLoggedIn(session);
    }

    public static void updateQuantity(HttpSession session, int variantId, int quantity) {
        List<CartItem> cart = getCart(session);
        for (CartItem ci : cart) {
            if (ci.getVariantId() == variantId) {
                if (quantity <= 0) {
                    cart.remove(ci);
                } else {
                    ci.setQuantity(quantity);
                }
                break;
            }
        }
        session.setAttribute(CART_SESSION_KEY, cart);
        persistIfLoggedIn(session);
    }

    public static void removeFromCart(HttpSession session, int variantId) {
        List<CartItem> cart = getCart(session);
        cart.removeIf(ci -> ci.getVariantId() == variantId);
        session.setAttribute(CART_SESSION_KEY, cart);
        persistIfLoggedIn(session);
    }

    public static void clearCart(HttpSession session) {
        List<CartItem> cart = getCart(session);
        cart.clear();
        session.setAttribute(CART_SESSION_KEY, cart);

        User user = (User) session.getAttribute("LOGIN_USER");
        if (user != null) {
            cartDAO.clearCartByUserId(user.getId());
        }
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

    public static void mergeOnLogin(HttpSession session, User user) {
        if (session.getAttribute(USER_CART_LOADED_KEY) != null) {
            return;
        }

        List<CartItem> dbCart = cartDAO.getCartByUserId(user.getId());
        List<CartItem> sessionCart = getCart(session);

        if (dbCart.isEmpty()) {
            session.setAttribute(CART_SESSION_KEY, sessionCart);
            if (!sessionCart.isEmpty()) {
                cartDAO.saveCart(user.getId(), sessionCart);
            }
        } else {
            List<CartItem> merged = mergeCarts(sessionCart, dbCart);
            session.setAttribute(CART_SESSION_KEY, merged);
            cartDAO.saveCart(user.getId(), merged);
        }

        session.setAttribute(USER_CART_LOADED_KEY, Boolean.TRUE);
    }

    private static List<CartItem> mergeCarts(List<CartItem> sessionCart, List<CartItem> dbCart) {
        List<CartItem> result = new ArrayList<>(dbCart);
        for (CartItem guestItem : sessionCart) {
            boolean found = false;
            for (CartItem dbItem : result) {
                if (dbItem.getVariantId() == guestItem.getVariantId()) {
                    dbItem.setQuantity(dbItem.getQuantity() + guestItem.getQuantity());
                    found = true;
                    break;
                }
            }
            if (!found) {
                result.add(guestItem);
            }
        }
        return result;
    }

    private static void persistIfLoggedIn(HttpSession session) {
        User user = (User) session.getAttribute("LOGIN_USER");
        if (user == null) return;
        if (session.getAttribute(USER_CART_LOADED_KEY) == null) return;
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) return;
        cartDAO.saveCart(user.getId(), cart);
    }
}