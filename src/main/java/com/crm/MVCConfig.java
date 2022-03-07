package com.crm;

import com.crm.settings.controller.Interceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MVCConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        String[] path = {"/**"};
        String[] excludePath = {"/user","/login.jsp","/image/**","/jquery/**"};
        registry.addInterceptor(new Interceptor()).addPathPatterns(path).excludePathPatterns(excludePath);
    }
}
