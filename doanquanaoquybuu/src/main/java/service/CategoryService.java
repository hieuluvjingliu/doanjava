package service;

import dao.DanhMucDAO;
import model.DanhMuc;

import java.util.Collections;
import java.util.List;

public class CategoryService {

    private final DanhMucDAO danhMucDAO = new DanhMucDAO();

    public List<DanhMuc> getAll() {
        List<DanhMuc> list = danhMucDAO.getAll();
        return list == null ? Collections.emptyList() : list;
    }

    public DanhMuc getById(int id) {
        if (id <= 0) return null;
        return danhMucDAO.getById(id);
    }

    public boolean create(DanhMuc dm) {
        if (dm == null || isEmpty(dm.getName())) return false;
        return danhMucDAO.insert(dm);
    }

    public boolean update(DanhMuc dm) {
        return dm != null && dm.getId() > 0 && danhMucDAO.update(dm);
    }

    public boolean delete(int id) {
        return id > 0 && danhMucDAO.delete(id);
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
