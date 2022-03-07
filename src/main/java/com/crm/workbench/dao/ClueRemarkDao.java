package com.crm.workbench.dao;

import com.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> select(String clueId);

    int insert(ClueRemark remark);

    int update(ClueRemark clueRemark);

    int delete(String Id);

    int deleteByClue(String[] clueIds);
}
