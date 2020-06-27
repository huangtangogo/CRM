package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.CustomerRemark;
import com.huangliutan.crm.workbench.mapper.CustomerRemarkMapper;
import com.huangliutan.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class CustomerRemarkController {
    @Autowired
    private CustomerRemarkService customerRemarkService;

    @RequestMapping("/workbench/customer/saveCustomerRemark.do")
    public @ResponseBody Object saveCustomerRemark(CustomerRemark customerRemark, HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);

        //封装参数
        customerRemark.setId(UUIDUtils.getUUID());
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag("0");

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service保存用户
            int ret = customerRemarkService.saveCreateCustomerRemark(customerRemark);
            if(ret > 0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(customerRemark);
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

    @RequestMapping("/workbench/customer/deleteCustomerRemark.do")
    public @ResponseBody Object deleteCustomerRemark(String id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service方法删除客户备注
            int ret = customerRemarkService.deleteCustomerRemarkById(id);
            if(ret>0){
                //删除成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //删除失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            e.printStackTrace();//一定记得写，不然异常不知道
            //删除失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/updateCustomerRemark.do")
    public @ResponseBody Object updateCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        customerRemark.setEditBy(user.getId());
        customerRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag("1");
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法更新备注
            int ret = customerRemarkService.updateCustomerRemark(customerRemark);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(customerRemark);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            e.printStackTrace();//经常不记得写
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }
}
