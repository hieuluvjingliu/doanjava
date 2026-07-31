package service;

import dao.SanPhamChiTietDAO;
import model.SanPhamChiTiet;

import java.util.List;

public class VariantService {

    private final SanPhamChiTietDAO spctDAO = new SanPhamChiTietDAO();

    public List<SanPhamChiTiet> getByProductId(int productId) {
        if (productId <= 0) return java.util.Collections.emptyList();
        return spctDAO.getByProductId(productId);
    }

    public SanPhamChiTiet findInList(List<SanPhamChiTiet> list, int variantId) {
        if (list == null) return null;
        for (SanPhamChiTiet v : list) {
            if (v.getId() == variantId) return v;
        }
        return null;
    }

    public boolean create(SanPhamChiTiet spct) {
        return spct != null && spct.getProductId() > 0 && spctDAO.insert(spct);
    }

    public boolean update(SanPhamChiTiet spct) {
        return spct != null && spct.getId() > 0 && spctDAO.update(spct);
    }

    public boolean delete(int id) {
        return id > 0 && spctDAO.delete(id);
    }

    public int getTotalStock(int productId) {
        if (productId <= 0) return 0;
        return spctDAO.getTotalQuantity(productId);
    }
}
