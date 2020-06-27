package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.DicValue;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.settings.service.DicValueService;
import com.huangliutan.crm.settings.service.UserService;
import com.huangliutan.crm.workbench.domain.*;
import com.huangliutan.crm.workbench.service.*;
import com.sun.tools.classfile.ConstantPool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ContactsController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;

    @RequestMapping("/workbench/contacts/index.do")
    public String index(Model model) {
        //调用service查询数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryAllDicValueByTypeCode("appellation");
        //将查询结果保存到request中
        model.addAttribute("userList", userList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("appellationList", appellationList);
        //请求转发
        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/queryCustomerForDetailByName.do")
    public @ResponseBody
    Object queryCustomerForDetailByName(String name) {
        //调用service方法查询客户
        List<Customer> customerList = customerService.queryCustomerForDetailByName(name);
        //返回响应信息
        return customerList;
    }

    @RequestMapping("/workbench/contacts/saveCreateContact.do")
    public @ResponseBody
    Object saveCreateContact(Contacts contacts,String customerName, HttpSession session) {
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));

        Map<String,Object> map = new HashMap<>();
        map.put("sessionUser",user);
        map.put("contacts",contacts);
        map.put("customerName",customerName);

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service保存联系人
            contactsService.saveCreateContact(map);
            //保存成功
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();//记得打印信息啊，好几次了都，找不到错误在哪
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/queryContactsForPage.do")
    public @ResponseBody Object queryContactsForPage(String owner,String fullName,String customerName,String source,String birth,Integer pageNo,Integer pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("fullName",fullName);
        map.put("customerName",customerName);
        map.put("source",source);
        map.put("birth",birth);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调用service方法查询数据
        List<Contacts> contactsList = contactsService.queryContactsForPageByCondition(map);
        long totalRows = contactsService.queryCountOfContactsByCondition(map);

        //生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("contactsList",contactsList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/contacts/queryContactsForDetailById.do")
    public String queryContactsForDetailById(String id,Model model){
        //调用service方法查询数据
        Contacts contacts = contactsService.queryContactsForDetailById(id);
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsRemarkByContactsId(id);
        List<Tran> tranList = tranService.queryTranOfContactsByContactsId(id);
        List<Activity> activityList = activityService.queryContactsActivityRelationByContactsId(id);

        //将查询结果保存到request中
        model.addAttribute("contacts",contacts);
        model.addAttribute("contactsRemarkList",contactsRemarkList);
        model.addAttribute("tranList",tranList);
        model.addAttribute("activityList",activityList);

        //调用service查询数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryAllDicValueByTypeCode("appellation");
        //将查询结果保存到request中
        model.addAttribute("userList", userList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("appellationList", appellationList);

        //请求转发
        return "workbench/contacts/detail";
    }

    @RequestMapping("/workbench/contacts/bundActivity.do")
    public @ResponseBody Object bundActivity(String name,String contactsId){
        //封装参数
        Map<String,Object> map =new HashMap<>();
        map.put("name",name);
        map.put("contactsId",contactsId);
        //调用service方法查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByNameAndContactsId(map);

        //返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/contacts/saveContactsActivityRelation.do")
    public @ResponseBody Object saveContactsActivityRelation(String contactsId,String[] activityId){
        //封装参数
        ContactsActivityRelation contactsActivityRelation = null;

        List<ContactsActivityRelation> list = new ArrayList<>();
        //遍历数组
        if(activityId!=null && activityId.length>0){
            for(String id:activityId){
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setActivityId(id);
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setContactsId(contactsId);
                list.add(contactsActivityRelation);
            }
        }

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法保存联系人关联市场活动
            int ret = contactsActivityRelationService.saveCreateContactsActivityRelationByList(list);
            if(ret>0){
                //查询市场活动
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityList);
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

    @RequestMapping("/workbench/contacts/deleteContactsActivityRelation.do")
    public @ResponseBody Object deleteContactsActivityRelation(ContactsActivityRelation contactsActivityRelation){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service方法删除关联关系
            int ret = contactsActivityRelationService.deleteContactsActivityRelationByContactsIdAndActivityId(contactsActivityRelation);
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
        return  returnObject;
    }

    @RequestMapping("/workbench/contacts/save.do")
    public String save(String id,String fullName,Model model){
        //调用service方法查询数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stages = dicValueService.queryAllDicValueByTypeCode("stage");
        List<DicValue> sources = dicValueService.queryAllDicValueByTypeCode("source");
        List<DicValue> types = dicValueService.queryAllDicValueByTypeCode("transactionType");

        //将查询结果，保存到request中
        model.addAttribute("id",id);
        model.addAttribute("fullName",fullName);
        model.addAttribute("userList",userList);
        model.addAttribute("stages",stages);
        model.addAttribute("sources",sources);
        model.addAttribute("types",types);

        //请求转发
        return "workbench/contacts/save";
    }

    @RequestMapping("/workbench/contacts/getPossibility.do")
    public @ResponseBody String getPossibility(String stageValue){
        //解析properties文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);

        //生成响应信息
        return possibility;
    }

    @RequestMapping("/workbench/contacts/queryActivityForDetailByName.do")
    public @ResponseBody Object queryActivityForDetailByName(String name){
        //调用service方法查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByName(name);

        //返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/contacts/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(Tran tran,String customerName,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        Map<String,Object> map = new HashMap<>();
        tran.setId(UUIDUtils.getUUID());
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        map.put("sessionUser",user);
        map.put("tran",tran);
        map.put("customerName",customerName);

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法保存交易
            tranService.saveCreateTran(map);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteTranByTranId.do")
    public @ResponseBody Object deleteTranByTranId(String tranId){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法删除交易
            tranService.deleteTranById(tranId);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactsByIds.do")
    public @ResponseBody Object deleteContactsByIds(String[] id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法删除联系人
            contactsService.deleteContactsByIds(id);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/queryContactsById.do")
    public @ResponseBody Object queryContactsById(String id){
        //调用service方法查询联系人
        Contacts contacts = contactsService.queryContactsById(id);
        //返回响应信息
        return contacts;
    }

    @RequestMapping("/workbench/contacts/updateContacts.do")
    public @ResponseBody Object updateContacts(Contacts contacts,String customerName,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        contacts.setEditBy(user.getId());
        contacts.setEditTime(DateUtils.formatDateTime(new Date()));

        Map<String,Object> map = new HashMap<>();
        map.put("sessionUser",user);
        map.put("contacts",contacts);
        map.put("customerName",customerName);

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service方法更新联系人
            contactsService.saveEditContacts(map);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            //查询联系人明细信息，此处是为了在明细界面编辑时使用
            Contacts contacts1 = contactsService.queryContactsForDetailById(contacts.getId());
            returnObject.setRetData(contacts1);

        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }
}
