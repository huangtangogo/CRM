package com.huangliutan.crm.settings.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.DicType;
import com.huangliutan.crm.settings.domain.DicValue;
import com.huangliutan.crm.settings.service.DicTypeService;
import com.huangliutan.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DicValueController {
    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/settings/dictionary/value/index.do")
    public String index(Model model) {
        //调用service方法查询数据字典值
        List<DicValue> dicValueList = dicValueService.queryAllDicValues();
        //将数据保存在request作用域中
        model.addAttribute("dicValueList", dicValueList);
        //请求转发
        return "settings/dictionary/value/index";
    }

    @RequestMapping("/settings/dictionary/value/toSave.do")
    public String toSave(Model model) {
        //调用service方法查询数据字典类型
        List<DicType> dicTypeList = dicTypeService.queryAllDicTypes();
        //将查询结果保存在request中
        model.addAttribute("dicTypeList", dicTypeList);
        //请求转发
        return "settings/dictionary/value/save";
    }

    @RequestMapping("/settings/dictionary/value/saveCreateDicValue.do")
    public @ResponseBody
    Object saveCreateDicValue(DicValue dicValue) {
        ReturnObject returnObject = new ReturnObject();
        //封装参数，因为客户端未知主键id存在，由程序员自己设置
        dicValue.setId(UUIDUtils.getUUID());
        try {
            //调用service保存数据字典值
            int ret = dicValueService.saveCreateDicValue(dicValue);
            //判断保存结果
            if (ret > 0) {
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/value/deleteDicValueByIds.do")
    public @ResponseBody
    Object deleteDicValueByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();

        try {
            //调用service方法删除数据字典值
            int ret = dicValueService.deleteDicValueByIds(id);
            if (ret > 0) {
                //删除成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //删除失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //删除失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/value/editDicValue.do")
    public String editDicValue(String id, Model model) {
        //调用业务层查询数据
        DicValue dicValue = dicValueService.queryDicValueById(id);
        //保存到request作用域中
        model.addAttribute("dicValue", dicValue);
        //请求转发
        return "settings/dictionary/value/edit";
    }

    @RequestMapping("/settings/dictionary/value/saveEditDicValue.do")
    public @ResponseBody Object saveEditDicValue(DicValue dicValue) {
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service修改数据字典值
            int ret = dicValueService.saveEditDicValue(dicValue);
            if (ret > 0) {
                //修改成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //修改失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //修改失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后重试...");
        }
        return returnObject;
    }
}
