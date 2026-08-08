package service;

import dao.SanPhamDAO;
import model.SanPham;
import model.SanPhamChiTiet;

import java.util.Collections;
import java.util.List;

/**
 * Service dùng cho phần client: trang chủ, trang chi tiết sản phẩm.
 */
public class CatalogService {

    private final SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private final VariantService variantService = new VariantService();

    public List<SanPham> getCatalog(String categoryParam, String keywordParam) {
        if (categoryParam != null && !categoryParam.isBlank()) {
            try {
                int cid = Integer.parseInt(categoryParam);
                return sanPhamDAO.getByCategoryId(cid);
            } catch (NumberFormatException ex) {
                return sanPhamDAO.getAll();
            }
        }
        if (keywordParam != null && !keywordParam.isBlank()) {
            return sanPhamDAO.searchByKeyword(keywordParam.trim());
        }
        return sanPhamDAO.getAll();
    }

    public SanPham getProductById(int id) {
        if (id <= 0) return null;
        return sanPhamDAO.getById(id);
    }

    public List<SanPham> getAllProducts() {
        List<SanPham> list = sanPhamDAO.getAll();
        return list == null ? Collections.emptyList() : list;
    }

    /**
     * Lấy N sản phẩm mới nhất (theo id DESC) để hiển thị trang chủ.
     */
    public List<SanPham> getNewestProducts(int limit) {
        if (limit <= 0) return Collections.emptyList();
        List<SanPham> list = sanPhamDAO.getNewest(limit);
        return list == null ? Collections.emptyList() : list;
    }

    public List<SanPhamChiTiet> getVariants(int productId) {
        return variantService.getByProductId(productId);
    }
}
