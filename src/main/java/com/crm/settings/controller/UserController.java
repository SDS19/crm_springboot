package com.crm.settings.controller;

import com.crm.settings.domain.User;
import com.crm.settings.service.UserService;
import com.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping("/login")
    @ResponseBody
    public Map<String,String> login(HttpServletRequest request, User user) {
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        user.setAllowIps(request.getRemoteAddr());
        Map<String,String> map = new HashMap<>();
        try {
            request.getSession(true).setAttribute("user",userService.login(user));
            map.put("success","1");
        }catch (Exception e){
            e.printStackTrace();
            map.put("success","0");
            map.put("msg",e.getMessage());
        } finally {
            return map;
        }
    }
}
