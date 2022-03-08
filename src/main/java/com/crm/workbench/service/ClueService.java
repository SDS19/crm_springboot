package com.crm.workbench.service;

import com.crm.exceptions.DaoException;
import com.crm.vo.Pagination;
import com.crm.workbench.domain.Clue;
import com.crm.workbench.domain.ClueRemark;
import com.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {

    void save(Clue clue) throws DaoException;

    Pagination<Clue> pageList(Clue clue) throws DaoException;

    Clue detail(String id);

    Map<String, Object> edit(String id);

    void update(Clue clue) throws DaoException;

    void delete(String[] ids) throws DaoException;

    void unbind(String id) throws DaoException;//delete relation between clue and activity

    void bind(String clueId,String[] activityIds) throws DaoException;

    void convert(String clueId, Tran tran) throws DaoException;//convert clue into transaction

    List<ClueRemark> getRemarksByClueId(String clueId);

    void addRemark(ClueRemark remark) throws DaoException;

    void updateRemark(ClueRemark remark) throws DaoException;

    void removeRemark(String id) throws DaoException;
}
