package com.crm.workbench.dao;

import com.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int total(Tran tran);

    List<Tran> tranList(Tran tran);

    int insert(Tran tran);

    Tran select(String id);

    int update(Tran tran);

    //ECharts data
    int max();

    List<Map<String, String>> dataList();//get value(number):name(stage) list of transactions
}
