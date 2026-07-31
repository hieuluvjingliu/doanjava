package service;

import dao.UserDAO;
import model.User;
import utils.Constants;

import java.util.regex.Pattern;

public class AuthService {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0[3-9])[0-9]{8}$");

    private final UserDAO userDAO = new UserDAO();

    public User login(String email, String password) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            return null;
        }
        return userDAO.login(email.trim(), password);
    }

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

    public boolean isEmail(String s) {
        return s != null && EMAIL_PATTERN.matcher(s).matches();
    }

    public boolean isPhone(String s) {
        return s != null && PHONE_PATTERN.matcher(s).matches();
    }

    public String validateEmail(String email) {
        if (email == null || email.isBlank()) return "Email không được để trống.";
        if (!isEmail(email.trim())) return "Email không đúng định dạng.";
        return null;
    }

    public String validatePassword(String password) {
        if (password == null || password.isEmpty()) return "Mật khẩu không được để trống.";
        if (password.length() < 6) return "Mật khẩu phải có ít nhất 6 ký tự.";
        return null;
    }

    public String validateFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) return "Họ tên không được để trống.";
        if (fullName.trim().length() < 2) return "Họ tên phải có ít nhất 2 ký tự.";
        if (fullName.trim().length() > 100) return "Họ tên quá dài (tối đa 100 ký tự).";
        return null;
    }

    public String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return null;
        if (!isPhone(phone.trim())) return "Số điện thoại không hợp lệ (VD: 0912345678).";
        return null;
    }
}
