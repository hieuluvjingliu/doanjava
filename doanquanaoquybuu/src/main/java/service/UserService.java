package service;

import dao.UserDAO;
import model.User;
import utils.Constants;

import java.util.Collections;
import java.util.List;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<User> getAll() {
        List<User> list = userDAO.getAll();
        return list == null ? Collections.emptyList() : list;
    }

    public User getById(int id) {
        return id > 0 ? userDAO.getById(id) : null;
    }

    /**
     * Tạo tài khoản mới. Trả về null nếu thành công, ngược lại trả mô tả lỗi.
     */
    public String create(User user) {
        if (user == null) return "Dữ liệu người dùng không hợp lệ.";
        if (user.getEmail() == null || user.getEmail().isBlank()) return "Email không được để trống.";
        if (user.getPasswordHash() == null || user.getPasswordHash().isBlank()) return "Mật khẩu không được để trống.";
        if (user.getRole() == null) user.setRole(Constants.ROLE_CUSTOMER);
        if (user.getStatus() == null) user.setStatus(Constants.STATUS_USER_ACTIVE);
        return userDAO.insert(user) ? null : "Email có thể đã tồn tại, vui lòng thử email khác.";
    }

    public boolean update(User user) {
        return user != null && user.getId() > 0 && userDAO.update(user);
    }

    /**
     * Chuyển trạng thái tài khoản (ACTIVE <-> INACTIVE).
     * Chặn admin tự khóa chính mình.
     */
    public boolean setStatus(int targetId, String newStatus, Integer currentAdminId) {
        if (targetId <= 0 || newStatus == null) return false;
        if (currentAdminId != null && currentAdminId == targetId) return false;
        return userDAO.setStatus(targetId, newStatus);
    }
}
