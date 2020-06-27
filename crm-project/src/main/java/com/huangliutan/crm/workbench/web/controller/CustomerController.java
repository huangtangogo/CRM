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
import jdk.nashorn.internal.ir.ReturnNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class CustomerController {
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/customer/index.do")
    public String index(Model model){
        //调用service方法查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //将查询结果保存到request作用域中
        model.addAttribute("userList",userList);
        //请求转发
        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    public @ResponseBody Object saveCreateCustomer(Customer customer, HttpSession session){
        //从session中获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法保存客户信息
            int ret = customerService.saveCreateCustomer(customer);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后...");
            }
        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerByCondition.do")
    public @ResponseBody Object queryCustomerByCondition(String name,String owner,String phone,String website,Integer pageNo,Integer pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调用service方法查询客户
        List<Customer> customerList = customerService.queryCustomerForPageByCondition(map);
        long totalRows = customerService.queryCountOfCustomerByCondition(map);

        //根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("customerList",customerList);
        retMap.put("totalRows",totalRows);

        //响应
        return retMap;
    }

    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    public @ResponseBody Object deleteCustomerByIds(String[] id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法删除客户信息
            int ret = customerService.deleteCustomerByIds(id);
            if(ret>0){
                //删除成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            e.printStackTrace();//一定要写啊
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    public @ResponseBody Object queryCustomerById(String id){
        //调用service方法查询客户信息
        Customer customer = customerService.queryCustomerById(id);
        //根据查询结果，生成响应信息
        return customer;
    }

    @RequestMapping("/workbench/customer/saveEditCustomer.do")
    public @ResponseBody Object saveEditCustomer(Customer customer,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDateTime(new Date()));
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法更新客户信息
            int ret = customerService.saveEditCustomer(customer);
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

    @RequestMapping("/workbench/customer/queryCustomerForDetailById.do")
    public Object queryCustomerForDetailById(String id,Model model){
        //调用service查询客户明细
        Customer customer = customerService.queryCustomerForDetailById(id);
        //调用service查询客户所有的备注
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkForDetailByCustomerId(id);
        //调用service查询客户所有的交易
        List<Tran> tranList = tranService.queryTranForDetailByCustomerId(id);
        //调用service查询客户所有的联系人
        List<Contacts> contactsList = contactsService.queryContactsForDetailByCustomerId(id);

        //设置到创建联系人的模态窗口
        //调用service查询数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryAllDicValueByTypeCode("appellation");
        //将查询结果保存到request中
        model.addAttribute("userList", userList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("appellationList", appellationList);

        //将查询结果保存到request中
        model.addAttribute("customer",customer);
        model.addAttribute("customerRemarkList",customerRemarkList);
        model.addAttribute("tranList",tranList);
        model.addAttribute("contactsList",contactsList);

        //请求转发
        return "workbench/customer/detail";
    }

    @RequestMapping("/workbench/customer/deleteTranOfCustomerDetail.do")
    public @ResponseBody Object deleteTranOfCustomerDetail(String tranId){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法删除交易
            int ret = tranService.deleteTranById(tranId);
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

    @RequestMapping("/workbench/customer/queryCustomerForDetailByName.do")
    public @ResponseBody Object queryCustomerForDetailByName(String name){
        //调用service方法查询客户信息
        List<Customer> customerList = customerService.queryCustomerForDetailByName(name);
        //返回响应信息
        return customerList;
    }

    @RequestMapping("/workbench/customer/saveCreateContactOfCustomer.do")
    public @ResponseBody Object saveCreateContactOfCustomer(Contacts contacts, HttpSession session) {
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));

        Map<String,Object> map = new HashMap<>();
        map.put("sessionUser",user);
        map.put("contacts",contacts);
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service保存联系人
            contactsService.saveCreateContact(map);
            //保存成功
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(contacts);
        } catch (Exception e) {
            e.printStackTrace();//记得打印信息啊，好几次了都，找不到错误在哪
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteContactsOfCustomerById.do")
    public @ResponseBody Object deleteContactsOfCustomerById(String id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try{
            //调用service方法删除联系人信息
            int ret = contactsService.deleteContactsById(id);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerAfterEditById.do")
    public @ResponseBody Object queryCustomerAfterEditById(String id){
        //调用service方法查询数据
        Customer customer = customerService.queryCustomerForDetailById(id);
        //返回响应信息
        return customer;
    }

    @RequestMapping("/workbench/customer/save.do")
    public String save(String customerId,String name,Model model){
        //将customerId保存到request中
        model.addAttribute("customerId",customerId);
        model.addAttribute("name",name);

        //调用service查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //调用service方法查询数据字典值

        List<DicValue> transactionTypeList = dicValueService.queryAllDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryAllDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode("source");

        //将查询结果保存到request中
        model.addAttribute("userList",userList);
        model.addAttribute("transactionTypeList",transactionTypeList);
        model.addAttribute("stageList",stageList);
        model.addAttribute("sourceList",sourceList);

        //请求转发
        return "workbench/customer/save";
    }

    @RequestMapping("/workbench/customer/getPossibilityByStageValue.do")
    public @ResponseBody Object getPossibilityByStageValue(String stageValue){
        //解析properties文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);

        //返回响应信息
        return possibility;
    }

    @RequestMapping("/workbench/customer/queryActivityForDetailByName.do")
    public @ResponseBody Object queryActivityForDetailByName(String name){
        //调用service模糊查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByName(name);
        //返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/customer/queryContactsForDetailByName.do")
    public @ResponseBody Object queryContactsForDetailByName(String name){
        //调用service方法查询联系人
        List<Contacts> contactsList = contactsService.queryContactsForDetailByName(name);
        //返回响应信息
        return contactsList;
    }

    @RequestMapping("/workbench/customer/queryCustomerByName.do")
    public @ResponseBody Object queryCustomerByName(String name){
        //调用service方法查询客户
        List<Customer> customerList = customerService.queryCustomerForDetailByName(name);
        //返回响应信息
        return customerList;
    }

    @RequestMapping("/workbench/customer/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(Tran tran, String customerId, HttpSession session){
        //获取User对象
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        tran.setId(UUIDUtils.getUUID());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        tran.setCreateBy(user.getId());

        Map<String,Object> map = new HashMap<>();
        map.put("sessionUser",user);
        map.put("customerId",customerId);
        map.put("tran",tran);

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //保存交易
            tranService.saveCreateTran(map);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            //保存失败
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

}
