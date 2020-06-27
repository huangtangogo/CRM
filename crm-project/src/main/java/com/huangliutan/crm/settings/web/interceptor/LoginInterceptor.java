package com.huangliutan.crm.settings.web.interceptor;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        //判断用户是否登录
        User user = (User)httpServletRequest.getSession().getAttribute(Constants.SessionParam.SESSION_USER);
        if(user == null){
            //没登录，重定向到首页，和业务无关的使用重定向
            httpServletResponse.sendRedirect(httpServletRequest.getContextPath());
            return false;//禁止访问
        }
        //如果已登录，就放行
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
