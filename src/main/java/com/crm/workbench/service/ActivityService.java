package com.crm.workbench.service;

import com.crm.exceptions.DaoException;
import com.crm.vo.Pagination;
import com.crm.workbench.domain.Activity;
import com.crm.workbench.domain.ActivityRemark;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ActivityService {

    /* ========================================= activity method ========================================= */

    void save(Activity activity) throws DaoException;

    Pagination<Activity> pageList(Activity activity) throws DaoException;

    void delete(String[] ids) throws DaoException;

    Map<String,Object> edit(String id);

    void update(Activity activity) throws DaoException;

    Activity detail(String id);

    List<Activity> getActivitiesByClueId(String clueId);

    List<Activity> getActivitiesForClue(HashMap<String,String> map);

    List<Activity> getActivitiesForTran(String name);

    /* ========================================= remark method ========================================= */

    List<ActivityRemark> select(String activityId);

    void removeRemark(String id) throws DaoException;

    void addRemark(ActivityRemark remark) throws DaoException;

    void updateRemark(ActivityRemark remark) throws DaoException;

}
