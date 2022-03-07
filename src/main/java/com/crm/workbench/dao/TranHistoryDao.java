package com.crm.workbench.dao;

import com.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int insert(TranHistory tranHistory);

    List<TranHistory> select(String tranId);
}
