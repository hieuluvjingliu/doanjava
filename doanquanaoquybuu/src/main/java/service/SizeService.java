package service;

import dao.KichThuocDAO;
import model.KichThuoc;

import java.util.Collections;
import java.util.List;

public class SizeService {

    private final KichThuocDAO kichThuocDAO = new KichThuocDAO();

    public List<KichThuoc> getAll() {
        List<KichThuoc> list = kichThuocDAO.getAll();
        return list == null ? Collections.emptyList() : list;
    }

    public KichThuoc getById(int id) {
        return id > 0 ? kichThuocDAO.getById(id) : null;
    }

    /**
     * Thêm kích thước mới. Trả về {@code null} nếu thành công, ngược lại trả mô tả lỗi.
     */
    public String create(KichThuoc kt) {
        if (kt == null || kt.getName() == null || kt.getName().trim().isEmpty()) {
            return "Tên kích thước không được để trống.";
        }
        if (kichThuocDAO.getByName(kt.getName().trim()) != null) {
            return "Kích thước đã tồn tại.";
        }
        return kichThuocDAO.insert(kt) ? null : "Thêm thất bại, vui lòng thử lại.";
    }

    public boolean update(KichThuoc kt) {
        return kt != null && kt.getId() > 0 && kichThuocDAO.update(kt);
    }

    public boolean delete(int id) {
        return id > 0 && kichThuocDAO.delete(id);
    }
}
