package com.huangliutan.crm.settings.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户登录处理器
 */
@Controller
public class UserController {
    @Autowired
    private UserService userService;
    /**
     * 该方法用于完成登录页面跳转的工作
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    /**
     * 该方法用于验证用户登录信息，并将结果响应json格式给浏览器
     * @param loginAct 用户名参数
     * @param loginPwd 用户密码
     * @param isRemPwd 用户是否勾选10天内免登陆
     * @param request HttpServletRequest请求参数
     * @return json格式结果
     */
    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        ReturnObject returnObject = new ReturnObject();
        //判断用户的cookie是否打开，不打开不允许操作,为什么可以判断，因为cookie中必存在sessionID，获取不到不就是没打开嘛
        Cookie[] cookies = request.getCookies();
        if(cookies == null){
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("请先打开cookie");
        }else{
            //调用业务层方法查询数据
            User user = userService.queryUserByLoginActAndPwd(map);
            //判断查询结果
            if(user == null){
                //考虑怎么响应结果给ajax请求，使用实体类
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("用户名或者密码错误");
            }else{
                //判断权限有没有到期
                //获取当前时间和用户权限期限的字符串类型一致，可以判断前后
                String nowTime = DateUtils.formatDateTime(new Date());
                if(nowTime.compareTo(user.getExpireTime())>0){
                    returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("用户权限已过期");
                }else if("0".equals(user.getLockState())){//判断锁定状态
                    returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("用户处于锁定状态");
                }else if(user.getAllowIps().contains(request.getRemoteAddr())){//判断域名是否合法
                    returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("当前使用网路域名受限");
                }else{
                    //登录成功
                    returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                   //登录成功，将用户设值到httpSession会话中
                    session.setAttribute(Constants.SessionParam.SESSION_USER,user);
                }
                //判断用户是否勾选十天免登陆
                if("true".equals(isRemPwd)){
                    //创建loginAct的cookie对象，设置存储时间为10天,并响应浏览器用于存储
                    Cookie c1 = new Cookie("loginAct",loginAct);
                    c1.setMaxAge(10*24*60*60);
                    response.addCookie(c1);

                    //创建loginPwd的cookie对象，设置存储时间为10天,并响应浏览器用于存储
                    Cookie c2 = new Cookie("loginPwd",loginPwd);
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c2);
                }else{//没有勾选，那么之前存储的cookie必须要删掉，因为客户下次登录想自己输入
                    //使用同名的cookie可以覆盖之前的cookie
                    Cookie c1 = new Cookie("loginAct",loginAct);
                    c1.setMaxAge(0);
                    response.addCookie(c1);

                    Cookie c2 = new Cookie("loginPwd",loginAct);
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;
    }

    /**
     * 该方法用于处理用户退出请求
     * @return 重定向新的页面路径
     */
    @RequestMapping("/settings/qx/user/logout.do")//settings/qx/user/必须和存储cookie的地址一致，不然会涉及到跨域问题
    public String logout(HttpSession session,HttpServletResponse response){
        //销毁cookie
        Cookie c1 = new Cookie("loginAct","1");
        c1.setMaxAge(0);
        response.addCookie(c1);

        Cookie c2 = new Cookie("loginPwd","1");
        c2.setMaxAge(0);
        response.addCookie(c2);

        //消除session，这个方法很危险，建议不要使用
        //session.invalidate();
        session.removeAttribute(Constants.SessionParam.SESSION_USER);

        //重定向
        return "redirect:/";
    }
}
