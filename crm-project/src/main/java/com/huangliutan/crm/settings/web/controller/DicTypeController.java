package com.huangliutan.crm.settings.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.settings.domain.DicType;
import com.huangliutan.crm.settings.mapper.DicTypeMapper;
import com.huangliutan.crm.settings.service.DicTypeService;
import com.huangliutan.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DicTypeController {
    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping("/settings/dictionary/type/index.do")
    public String index(Model model) {
        //调用业务层查找数据字典数据
        List<DicType> dicTypeList = dicTypeService.queryAllDicTypes();

        //将结果设置到请求作用域中
        model.addAttribute("dicTypeList", dicTypeList);

        //请求转发到index.jsp页面
        return "settings/dictionary/type/index";
    }

    @RequestMapping("/settings/dictionary/type/toSave.do")
    public String toSave() {
        return "settings/dictionary/type/save";
    }

    @RequestMapping("/settings/dictionary/type/checkCode.do")
    public @ResponseBody
    Object checkCode(String code) {
        DicType dicType = dicTypeService.queryDicTypeByCode(code);
        ReturnObject returnObject = new ReturnObject();
        //判断结果是否存在
        if (dicType != null) {
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("编码不能重复");
        } else {
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/type/saveCreateDicType.do")
    public @ResponseBody
    Object saveCreateDicType(DicType dicType) {

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        //判断添加是否成功，可能添加时出现异常
        try {
            //调用service层方法保存数据
            int ret = dicTypeService.saveCreateDicType(dicType);
            if (ret > 0) {
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("保存失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("保存失败");
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/type/deleteDicTypeByCodes.do")
    public @ResponseBody Object deleteDicTypeByCodes(String[] code){//参数名必须和前台保持一致
        ReturnObject returnObject = new ReturnObject();
        try {//涉及到数据库的操作均要考虑异常
            int ret = dicTypeService.deleteDicTypeByCodes(code);

            if(ret > 0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("后台正忙，请稍后重试...");//不要直接告诉客户错误信息
            }
        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("后台正忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/settings/dictionary/type/editDicType.do")
    public String editDicType(String code,Model model){
        ReturnObject returnObject = new ReturnObject();
        //肯定存在
        DicType dicType = dicTypeService.queryDicTypeByCode(code);
        model.addAttribute("dicType",dicType);
        return "settings/dictionary/type/edit";
    }

    @RequestMapping("/settings/dictionary/type/saveEditDicType.do")
    public @ResponseBody Object saveEditDicType(DicType dicType){
        ReturnObject returnObject = new ReturnObject();
        try{
            //保存数据
            int ret = dicTypeService.saveEditDicType(dicType);
            if(ret > 0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("后台正忙，请稍后重试...");
            }
        }catch (Exception e){
            //保存失败
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("后台正忙，请稍后重试...");
        }
        return returnObject;
    }
}
