package com.crm.workbench.dao;

import com.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int count(String[] ids);

    int delete(String[] ids);

    List<ActivityRemark> select(String activityId);

    int insert(ActivityRemark remark);

    int remove(String id);

    int update(ActivityRemark remark);
}
