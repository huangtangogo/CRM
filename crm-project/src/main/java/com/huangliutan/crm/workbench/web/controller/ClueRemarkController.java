package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.workbench.domain.ClueRemark;
import com.huangliutan.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public @ResponseBody Object saveCreateClueRemark(ClueRemark remark, HttpSession session) {
        //获取当前用户信息
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateBy(user.getId());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        remark.setEditFlag("0");

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用业务层方法保存线索备注
            int ret = clueRemarkService.saveCreateClueRemark(remark);
            if (ret > 0) {
                //添加成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            } else {
                //添加失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //添加失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueRemark.do")
    public @ResponseBody Object deleteClueRemark(String id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用业务层方法删除线索备注
            int ret = clueRemarkService.deleteClueRemarkById(id);
            if(ret>0){
                //删除成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //删除失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            e.printStackTrace();
            //删除失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveEditRemark.do")
    public @ResponseBody Object saveEditRemark(ClueRemark remark,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        remark.setEditBy(user.getId());
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditFlag("1");

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用业务层方法修改线索备注
            int ret = clueRemarkService.saveEditClueRemark(remark);
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
}