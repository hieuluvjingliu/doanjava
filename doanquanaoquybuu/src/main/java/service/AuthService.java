package service;

import dao.UserDAO;
import model.User;
import utils.Constants;

import java.util.regex.Pattern;

/**
 * Service xử lý xác thực, đăng ký, và validate cho hệ thống.
 * Cung cấp các quy tắc dùng chung cho {@code login}, {@code register},
 * và cho form phía client (validate email, phone, password, fullName).
 */
public class AuthService {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0[3-9])[0-9]{8}$");

    private final UserDAO userDAO = new UserDAO();

    /**
     * Đăng nhập. Tài khoản phải ở trạng thái {@link Constants#STATUS_USER_ACTIVE}.
     * @param email email người dùng
     * @param password mật khẩu plaintext
     * @return {@link User} nếu thành công, {@code null} nếu thất bại
     */
    public User login(String email, String password) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            return null;
        }
        return userDAO.login(email.trim(), password);
    }

    /**
     * Đăng ký tài khoản mới với kiểm tra hợp lệ đầy đủ.
     * @return {@code null} nếu thành công, ngược lại trả về thông báo lỗi
     */
    public String register(String fullName, String email, String phone, String address, String password) {
        String fullNameE = validateFullName(fullName);
        if (fullNameE != null) return fullNameE;
        String emailE = validateEmail(email);
        if (emailE != null) return emailE;
        String phoneE = validatePhone(phone);
        if (phoneE != null) return phoneE;
        String passE = validatePassword(password);
        if (passE != null) return passE;

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone == null ? "" : phone.trim());
        user.setAddress(address == null ? "" : address.trim());
        user.setPasswordHash(password);
        user.setRole(Constants.ROLE_CUSTOMER);
        user.setStatus(Constants.STATUS_USER_ACTIVE);

        boolean ok = userDAO.insert(user);
        return ok ? null : "Đăng ký thất bại, email có thể đã tồn tại!";
    }

    /** @return {@code true} nếu chuỗi là email hợp lệ. */
    public boolean isEmail(String s) {
        return s != null && EMAIL_PATTERN.matcher(s).matches();
    }

    /** @return {@code true} nếu chuỗi là số điện thoại di động Việt Nam hợp lệ. */
    public boolean isPhone(String s) {
        return s != null && PHONE_PATTERN.matcher(s).matches();
    }

    /** @return {@code null} nếu hợp lệ, ngược lại trả thông báo lỗi. */
    public String validateEmail(String email) {
        if (email == null || email.isBlank()) return "Email không được để trống.";
        if (!isEmail(email.trim())) return "Email không đúng định dạng.";
        return null;
    }

    /** @return {@code null} nếu hợp lệ, ngược lại trả thông báo lỗi. */
    public String validatePassword(String password) {
        if (password == null || password.isEmpty()) return "Mật khẩu không được để trống.";
        if (password.length() < 6) return "Mật khẩu phải có ít nhất 6 ký tự.";
        return null;
    }

    /** @return {@code null} nếu hợp lệ, ngược lại trả thông báo lỗi. */
    public String validateFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) return "Họ tên không được để trống.";
        if (fullName.trim().length() < 2) return "Họ tên phải có ít nhất 2 ký tự.";
        if (fullName.trim().length() > 100) return "Họ tên quá dài (tối đa 100 ký tự).";
        return null;
    }

    /** @return {@code null} nếu hợp lệ (hoặc rỗng), ngược lại trả thông báo lỗi. */
    public String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return null;
        if (!isPhone(phone.trim())) return "Số điện thoại không hợp lệ (VD: 0912345678).";
        return null;
    }
}
