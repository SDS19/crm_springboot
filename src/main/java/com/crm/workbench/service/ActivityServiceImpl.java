package com.crm.workbench.service;

import com.crm.exceptions.DaoException;
import com.crm.settings.dao.UserDao;
import com.crm.vo.Pagination;
import com.crm.workbench.dao.ActivityDao;
import com.crm.workbench.dao.ActivityRemarkDao;
import com.crm.workbench.domain.Activity;
import com.crm.workbench.domain.ActivityRemark;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService{

    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;
    @Resource
    private UserDao userDao;

    /* ========================================= activity method ========================================= */

    @Override
    public void save(Activity activity) throws DaoException {
        if (activityDao.insert(activity)!=1) throw new DaoException("Create activity failed!");
    }

    @Override
    public Pagination<Activity> pageList(Activity activity) throws DaoException {
        int total = activityDao.total(activity);
        List<Activity> list = activityDao.activityList(activity);
        if (total!=0 && list==null) throw new DaoException("Activities query failed!");
        return new Pagination<>(total,list);
    }

    @Transactional
    @Override
    public void delete(String[] ids) throws DaoException{
        activityRemarkDao.delete(ids);
        if (activityDao.delete(ids)!=ids.length) throw new DaoException("Activity delete failed!");
    }

    @Override
    public Map<String, Object> edit(String id) {
        Map<String,Object> map = new HashMap<>();
        map.put("list",userDao.owner());
        map.put("activity",activityDao.edit(id));
        return map;
    }

    @Override
    public void update(Activity activity) throws DaoException{
        if (activityDao.update(activity)!=1) throw new DaoException("Activity update failed!");
    }

    @Override
    public Activity detail(String id) {
        return activityDao.selectById(id);
    }

    /* ========================================= remark method ========================================= */

    @Override
    public List<ActivityRemark> select(String activityId) {
        return activityRemarkDao.select(activityId);
    }

    @Override
    public void removeRemark(String id) throws DaoException{
        if (activityRemarkDao.remove(id)!=1) throw new DaoException("Delete remark failed!");
    }

    @Override
    public void addRemark(ActivityRemark remark) throws DaoException {
        if (activityRemarkDao.insert(remark)!=1) throw new DaoException("Insert remark failed!");
    }

    @Override
    public void updateRemark(ActivityRemark remark) throws DaoException {
        if (activityRemarkDao.update(remark)!=1) throw new DaoException("Update remark failed!");
    }

    @Override
    public List<Activity> getActivitiesByClueId(String clueId) {
        return activityDao.selectByClueId(clueId);
    }

    @Override
    public List<Activity> getActivitiesForClue(HashMap<String,String> map) {
        return activityDao.selectByNameForClue(map);
    }

    @Override
    public List<Activity> getActivitiesForTran(String name) {
        return activityDao.selectByNameForTran(name);
    }
}
