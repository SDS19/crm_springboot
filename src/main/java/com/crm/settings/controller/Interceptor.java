package com.crm.settings.controller;

import com.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Interceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user = (User) request.getSession().getAttribute("user");
        String ajax = request.getHeader("X-Requested-With");
        if (user==null) {
            String path = request.getContextPath();
            String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
            if ("XMLHttpRequest".equals(ajax)) {
                response.setHeader("x-Redirect","true");
                response.setHeader("x-Path",basePath+"login.jsp");
                return false;
            }else {
                System.err.println("redirect!");
                response.sendRedirect(basePath+"login.jsp");
                return false;
            }
        }
        return true;
    }
}
