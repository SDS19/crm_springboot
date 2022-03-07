package com.crm.workbench.dao;

import com.crm.workbench.domain.Activity;

import java.util.HashMap;
import java.util.List;

public interface ActivityDao {

    int insert(Activity activity);

    int total(Activity activity);

    List<Activity> activityList(Activity activity);

    int delete(String[] ids);

    Activity edit(String id);

    int update(Activity activity);

    Activity selectById(String id);

    List<Activity> selectByClueId(String clueId);

    List<Activity> selectByNameForClue(HashMap<String,String> map);

    List<Activity> selectByNameForTran(String name);

}
