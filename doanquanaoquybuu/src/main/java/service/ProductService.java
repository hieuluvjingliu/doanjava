package service;

import dao.SanPhamDAO;
import model.SanPham;

import java.util.Collections;
import java.util.List;

/**
 * Service xử lý nghiệp vụ sản phẩm: CRUD, phân trang, tìm kiếm.
 * Tương tác với tầng {@link SanPhamDAO} để truy vấn cơ sở dữ liệu.
 */
public class ProductService {

    private final SanPhamDAO sanPhamDAO = new SanPhamDAO();

    /**
     * Lấy toàn bộ sản phẩm trong hệ thống.
     * @return danh sách sản phẩm (không null; danh sách rỗng nếu lỗi)
     */
    public List<SanPham> getAll() {
        List<SanPham> list = sanPhamDAO.getAll();
        return list == null ? Collections.emptyList() : list;
    }

    /**
     * Lấy một trang sản phẩm theo phân trang (sắp xếp theo id giảm dần).
     * @param page trang hiện tại (bắt đầu từ 1)
     * @param pageSize số phần tử mỗi trang
     * @return danh sách sản phẩm trong trang
     */
    public List<SanPham> getByPage(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        int offset = (page - 1) * pageSize;
        return sanPhamDAO.getByPage(offset, pageSize);
    }

    /** @return tổng số sản phẩm trong cơ sở dữ liệu. */
    public int countAll() {
        return sanPhamDAO.countAll();
    }

    /**
     * Tính tổng số trang theo {@code pageSize} cho trang danh sách.
     * @return tổng trang (luôn &ge; 1)
     */
    public int calcTotalPages(int pageSize) {
        int total = countAll();
        if (total <= 0) return 1;
        return (int) Math.ceil((double) total / pageSize);
    }

    /**
     * Lấy chi tiết sản phẩm theo id.
     * @param id mã sản phẩm
     * @return sản phẩm hoặc {@code null} nếu không tìm thấy / id không hợp lệ
     */
    public SanPham getById(int id) {
        if (id <= 0) return null;
        return sanPhamDAO.getById(id);
    }

    /**
     * Tạo sản phẩm mới.
     * @return {@code true} nếu thêm thành công
     */
    public boolean create(SanPham sp) {
        return sp != null && sanPhamDAO.insert(sp);
    }

    /**
     * Cập nhật sản phẩm đã tồn tại.
     * @return {@code true} nếu cập nhật thành công
     */
    public boolean update(SanPham sp) {
        return sp != null && sp.getId() > 0 && sanPhamDAO.update(sp);
    }

    /**
     * Xóa sản phẩm theo id.
     * @return {@code true} nếu xóa thành công
     */
    public boolean delete(int id) {
        return id > 0 && sanPhamDAO.delete(id);
    }

    /**
     * Tìm sản phẩm theo từ khóa (tên hoặc mô tả).
     * @param keyword từ khóa, có thể null hoặc rỗng
     * @return danh sách sản phẩm phù hợp
     */
    public List<SanPham> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return Collections.emptyList();
        return sanPhamDAO.searchByKeyword(keyword.trim());
    }
}
