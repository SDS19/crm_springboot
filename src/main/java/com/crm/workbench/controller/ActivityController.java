package com.crm.workbench.controller;

import com.crm.exceptions.DaoException;
import com.crm.settings.domain.User;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.crm.vo.Pagination;
import com.crm.workbench.domain.Activity;
import com.crm.workbench.domain.ActivityRemark;
import com.crm.workbench.service.ActivityService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/activity")
public class ActivityController {

    @Resource
    private ActivityService activityService;

    /* ========================================= activity controller ========================================= */

    @GetMapping
    public Pagination<Activity> activityList(Integer pageNo, Integer pageSize, Activity activity){
        activity.setPageCount((pageNo-1)*pageSize);
        try {
            return activityService.pageList(activity);
        } catch (DaoException e) {
            e.printStackTrace();
            return null;
        }
    }

    @PostMapping
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

    @DeleteMapping
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

    @GetMapping("/edit")
    public Map<String,Object> edit(String id){
        return activityService.edit(id);
    }

    @PutMapping
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

    @GetMapping("/{id}")
    public ModelAndView detail(@PathVariable String id) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("activity",activityService.detail(id));
        mv.setViewName("workbench/activity/detail");
        return mv;
    }

    /* ========================================== remark controller ========================================== */

    @GetMapping("/remark/{activityId}")
    public List<ActivityRemark> remarkList(@PathVariable String activityId){
        return activityService.select(activityId);
    }

    @DeleteMapping("/remark/{id}")
    public String removeRemark(@PathVariable String id){
        try {
            activityService.removeRemark(id);
            return "1";
        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        }
    }

    @PostMapping("/remark")
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

    @PutMapping("/remark")
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
