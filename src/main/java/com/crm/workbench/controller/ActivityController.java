package com.crm.workbench.controller;

import com.crm.exceptions.DaoException;
import com.crm.settings.domain.User;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.crm.vo.Pagination;
import com.crm.workbench.domain.Activity;
import com.crm.workbench.domain.ActivityRemark;
import com.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
public class ActivityController {
    @Autowired
    private ActivityService activityService;

    /* ========================================= activity controller ========================================= */

    @RequestMapping("/activities")
    @ResponseBody
    public Pagination<Activity> activityList(Integer pageNo, Integer pageSize, Activity activity){
        activity.setPageCount((pageNo-1)*pageSize);
        try {
            return activityService.pageList(activity);
        } catch (DaoException e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping("/save")
    @ResponseBody
    public String save(HttpServletRequest request, Activity activity){
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy(((User)request.getSession(false).getAttribute("user")).getName());
        try {
            activityService.save(activity);
            return "1";
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    @RequestMapping("/delete")
    @ResponseBody
    public String delete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        try {
            activityService.delete(ids);
            return "1";
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    @RequestMapping("/edit")
    @ResponseBody
    public Map<String,Object> edit(String id){
        return activityService.edit(id);
    }

    @RequestMapping("/update")
    @ResponseBody
    public String update(HttpServletRequest request,Activity activity){
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(((User)request.getSession(false).getAttribute("user")).getName());
        try {
            activityService.update(activity);
            return "1";
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    @RequestMapping("/detail")
    public ModelAndView detail(String id) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("activity",activityService.detail(id));
        mv.setViewName("workbench/activity/detail");
        return mv;
    }

    /* ========================================== remark controller ========================================== */

    @RequestMapping("/remarks")
    @ResponseBody
    public List<ActivityRemark> remarkList(String activityId){
        return activityService.select(activityId);
    }

    @RequestMapping("/removeRemark")
    @ResponseBody
    public String removeRemark(String id){
        try {
            activityService.removeRemark(id);
            return "1";
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    @RequestMapping("/addRemark")
    @ResponseBody
    public Object addRemark(HttpServletRequest request, ActivityRemark remark){
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setCreateBy(((User) request.getSession(false).getAttribute("user")).getName());
        try {
            activityService.addRemark(remark);
            return remark;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping("/updateRemark")
    @ResponseBody
    public Object updateRemark(HttpServletRequest request, ActivityRemark remark){
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditBy(((User) request.getSession(false).getAttribute("user")).getName());
        try {
            activityService.updateRemark(remark);
            return remark;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
