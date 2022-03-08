package com.crm.settings.controller;

import com.crm.settings.domain.User;
import com.crm.settings.service.UserService;
import com.crm.utils.MD5Util;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class UserController {

    @Resource
    private UserService userService;

    @PostMapping("/user")
    public Map<String,String> signin(HttpServletRequest request,User user) {
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        user.setAllowIps(request.getRemoteAddr());
        Map<String,String> map = new HashMap<>();
        try {
            request.getSession().setAttribute("user",userService.login(user));
            map.put("success","1");
        }catch (Exception e){
            e.printStackTrace();
            map.put("success","0");
            map.put("msg",e.getMessage());
        } finally {
            return map;
        }
    }

    @GetMapping("/owner")
    public List<User> owner() {
        return userService.owner();
    }

    @GetMapping("/user")
    public void signout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().invalidate();
        response.sendRedirect("login.jsp");
    }
}
