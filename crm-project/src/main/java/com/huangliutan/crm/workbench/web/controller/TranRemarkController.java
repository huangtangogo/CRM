package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.Contacts;
import com.huangliutan.crm.workbench.domain.TranRemark;
import com.huangliutan.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class TranRemarkController {
    @Autowired
    private TranRemarkService tranRemarkService;

    @RequestMapping("/workbench/transaction/saveCreateTranRemark.do")
    public @ResponseBody Object saveCreateTranRemark(TranRemark tranRemark, HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        tranRemark.setId(UUIDUtils.getUUID());
        tranRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        tranRemark.setCreateBy(user.getId());
        tranRemark.setEditFlag("0");
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法保存对象
            int ret = tranRemarkService.saveCreateTranRemark(tranRemark);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(tranRemark);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }

        }catch (Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTranRemarkById.do")
    public @ResponseBody Object deleteTranRemarkById(String id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法删除交易备注
            int ret = tranRemarkService.deleteTranRemarkById(id);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/saveEditTranRemark.do")
    public @ResponseBody Object saveEditTranRemark(TranRemark tranRemark,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封住参数
        tranRemark.setEditBy(user.getId());
        tranRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        tranRemark.setEditFlag("1");
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service保存更新备注
            int ret = tranRemarkService.saveEditTranRemark(tranRemark);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(tranRemark);
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
