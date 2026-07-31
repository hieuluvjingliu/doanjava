package service;

import dao.SanPhamDAO;
import model.SanPham;

import java.util.Collections;
import java.util.List;

public class ProductService {

    private final SanPhamDAO sanPhamDAO = new SanPhamDAO();

    public List<SanPham> getAll() {
        return sanPhamDAO.getAll();
    }

    public List<SanPham> getByPage(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        int offset = (page - 1) * pageSize;
        return sanPhamDAO.getByPage(offset, pageSize);
    }

    public int countAll() {
        return sanPhamDAO.countAll();
    }

    public int calcTotalPages(int pageSize) {
        int total = countAll();
        if (total <= 0) return 1;
        return (int) Math.ceil((double) total / pageSize);
    }

    public SanPham getById(int id) {
        if (id <= 0) return null;
        return sanPhamDAO.getById(id);
    }

    public boolean create(SanPham sp) {
        return sp != null && sanPhamDAO.insert(sp);
    }

    public boolean update(SanPham sp) {
        return sp != null && sp.getId() > 0 && sanPhamDAO.update(sp);
    }

    public boolean delete(int id) {
        return id > 0 && sanPhamDAO.delete(id);
    }

    public List<SanPham> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return Collections.emptyList();
        return sanPhamDAO.searchByKeyword(keyword.trim());
    }
}
