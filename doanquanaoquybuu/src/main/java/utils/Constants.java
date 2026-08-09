package utils;

public final class Constants {

    private Constants() {}

    public static final String SESSION_USER = "LOGIN_USER";
    public static final String SESSION_CART = "CART";

    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_CUSTOMER = "CUSTOMER";

    public static final String STATUS_USER_ACTIVE = "ACTIVE";
    public static final String STATUS_USER_INACTIVE = "LOCKED";

    public static final String ORDER_PENDING   = "PENDING";
    public static final String ORDER_CONFIRMED = "CONFIRMED";
    public static final String ORDER_SHIPPING  = "SHIPPING";
    public static final String ORDER_FINISH    = "FINISH";
    public static final String ORDER_CANCELLED = "CANCELLED";

    public static final String PAYMENT_COD = "COD";
    public static final String PAYMENT_TRANSFER = "TRANSFER";

    public static final String ATTR_ERROR   = "error";
    public static final String ATTR_SUCCESS = "success";
    public static final String ATTR_CONTENT_PAGE = "contentPage";

    public static final int DEFAULT_PAGE_SIZE = 10;
}
