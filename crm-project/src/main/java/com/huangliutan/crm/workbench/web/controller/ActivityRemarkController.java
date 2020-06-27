package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.ActivityRemark;
import com.huangliutan.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    public @ResponseBody Object saveCreateActivityRemark(ActivityRemark remark, HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateBy(user.getId());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setEditFlag("0");
        //创建对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用业务层方法保存备注
            int ret = activityRemarkService.saveCreateActivityRemark(remark);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }

        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemark.do")
    public @ResponseBody Object deleteActivityRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用业务层方法删除数据
            int ret = activityRemarkService.deleteActivityRemarkById(id);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public @ResponseBody Object saveEditActivityRemark(ActivityRemark remark,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);

        //封装参数
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditBy(user.getId());
        remark.setEditFlag("1");

        //响应结果
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用业务层方法更新备注
            int ret = activityRemarkService.saveEditActivityRemark(remark);
            if(ret>0){
                //更新成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }

        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }
}
