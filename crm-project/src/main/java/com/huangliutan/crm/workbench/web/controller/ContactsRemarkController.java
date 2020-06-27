package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.Contacts;
import com.huangliutan.crm.workbench.domain.ContactsRemark;
import com.huangliutan.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ContactsRemarkController {
    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @RequestMapping("/workbench/contacts/saveCreateContactsRemark.do")
    public @ResponseBody Object saveCreateContactsRemark(ContactsRemark contactsRemark, HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);

        //封装参数
        contactsRemark.setCreateBy(user.getId());
        contactsRemark.setId(UUIDUtils.getUUID());
        contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        contactsRemark.setEditFlag("0");

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法保存联系人备注
            int ret= contactsRemarkService.saveCreateContactsRemark(contactsRemark);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(contactsRemark);
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

    @RequestMapping("/workbench/contacts/deleteContactsRemark.do")
    public @ResponseBody Object deleteContactsRemark(String id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service方法删除联系人备注
            int ret = contactsRemarkService.deleteContactsRemarkById(id);
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

    @RequestMapping("/workbench/contacts/saveEditContactsRemark.do")
    public @ResponseBody Object saveEditContactsRemark(ContactsRemark remark,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);

        //封装参数
        remark.setEditFlag("1");
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditBy(user.getId());

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法更新备注
            int ret = contactsRemarkService.saveEditContactsRemark(remark);
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
        return returnObject;
    }
}
