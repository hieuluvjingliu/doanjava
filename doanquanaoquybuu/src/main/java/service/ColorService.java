package service;

import dao.MauSacDAO;
import model.MauSac;

import java.util.Collections;
import java.util.List;

public class ColorService {

    private final MauSacDAO mauSacDAO = new MauSacDAO();

    public List<MauSac> getAll() {
        List<MauSac> list = mauSacDAO.getAll();
        return list == null ? Collections.emptyList() : list;
    }

    public MauSac getById(int id) {
        return id > 0 ? mauSacDAO.getById(id) : null;
    }

    public boolean create(MauSac ms) {
        return ms != null && mauSacDAO.insert(ms);
    }

    public boolean update(MauSac ms) {
        return ms != null && ms.getId() > 0 && mauSacDAO.update(ms);
    }

    public boolean delete(int id) {
        return id > 0 && mauSacDAO.delete(id);
    }
}
