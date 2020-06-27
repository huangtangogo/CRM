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
import com.sun.tools.internal.jxc.ap.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TranController {
    @Autowired
    private TranService tranService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranRemarkService tranRemarkService;
    @Autowired
    private TranHistoryService tranHistoryService;

    @RequestMapping("/workbench/transaction/index.do")
    public String index(Model model){
        //调用service方法查询数据字典值
        List<DicValue> transactionTypeList = dicValueService.queryAllDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryAllDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode("source");

        //将查询结果保存到request中
        model.addAttribute("transactionTypeList",transactionTypeList);
        model.addAttribute("stageList",stageList);
        model.addAttribute("sourceList",sourceList);

        //请求转发
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/save.do")
    public String save(Model model){

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
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStageValue.do")
    public @ResponseBody Object getPossibilityByStageValue(String stageValue){
        //解析properties文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);

        //返回响应信息
        return possibility;
    }

    @RequestMapping("/workbench/transaction/queryActivityForDetailByName.do")
    public @ResponseBody Object queryActivityForDetailByName(String name){
        //调用service模糊查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByName(name);
        //返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryContactsForDetailByName.do")
    public @ResponseBody Object queryContactsForDetailByName(String name){
        //调用service方法查询联系人
        List<Contacts> contactsList = contactsService.queryContactsForDetailByName(name);
        //返回响应信息
        return contactsList;
    }

    @RequestMapping("/workbench/transaction/queryCustomerByName.do")
    public @ResponseBody Object queryCustomerByName(String name){
        //调用service方法查询客户
        List<Customer> customerList = customerService.queryCustomerForDetailByName(name);
        //返回响应信息
        return customerList;
    }

    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(Tran tran, String customerName, HttpSession session){
        //获取User对象
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        tran.setId(UUIDUtils.getUUID());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        tran.setCreateBy(user.getId());

        Map<String,Object> map = new HashMap<>();
        map.put("sessionUser",user);
        map.put("customerName",customerName);
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

    @RequestMapping("/workbench/transaction/queryTranForPageByCondition.do")
    public @ResponseBody Object queryTranForPageByCondition(Integer pageNo,Integer pageSize,String ownerName,String customerName,String tranName,String contactsName,String stage,String type,String source){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        map.put("ownerName",ownerName);
        map.put("customerName",customerName);
        map.put("tranName",tranName);
        map.put("contactsName",contactsName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);

        //调用service查询数据
        List<Tran> tranList = tranService.queryTranForPageByCondition(map);
        long totalRows = tranService.queryCountOfTranByCondition(map);

        //生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("tranList",tranList);
        retMap.put("totalRows",totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/transaction/queryTranForDetail.do")
    public String queryTranForDetail(String id,Model model){
        //System.out.println("id"+id);
        //调用service方法查询数据
        Tran tran = tranService.queryTranForDetailById(id);
        //System.out.println(tran.getId());
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkForDetailByTranId(id);
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryForDetailByTranId(id);
        List<DicValue> stageList = dicValueService.queryAllDicValueByTypeCode("stage");

        //将查询结果保存到request中
        model.addAttribute("tran",tran);
        model.addAttribute("tranRemarkList",tranRemarkList);
        model.addAttribute("tranHistoryList",tranHistoryList);
        model.addAttribute("stageList",stageList);

        //读取配置文件，这里是测试使用配置文件参与项目构建，不建议实际开发中使用，涉及到磁盘文件的读操作，效率低
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());
        model.addAttribute("possibility",possibility);

        //前台无法获取到的数据在后台获取
        //遍历交易历史记录，获取交易历史在成功之前到达的阶段，从后往前判断好判断
        TranHistory tranHistory = null;
        for(int i=tranHistoryList.size()-1;i>=0;i--){
            //获取交易历史对象
            tranHistory = tranHistoryList.get(i);//从后往前第一个就是
            //找到成功之前到达的阶段的orderNo，根据orderNo判断,找到成功的编号
            if(Integer.parseInt(tranHistory.getOrderNo())< Integer.parseInt(stageList.get(stageList.size()-3).getOrderNo())){
                //将OrderNo保存到request中
                //System.out.println("--------------"+tranHistory.getOrderNo());
                model.addAttribute("theOrderNo",tranHistory.getOrderNo());

                //循环结束
                break;
            }
        }

        //请求转发
        return "workbench/transaction/detail";

    }

    @RequestMapping("/workbench/transaction/deleteTranByIds.do")
    public @ResponseBody Object deleteTranByIds(String[] id){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法删除交易
            tranService.deleteTranByIds(id);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    public @ResponseBody Object queryCountOfTranGroupByStage(){
        List<FunnelVo> funnelVoList = tranService.queryCountOfTranGroupByStage();
        return funnelVoList;
    }

    @RequestMapping("/workbench/transaction/edit.do")
    public String edit(String id,Model model){

        //调用service查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //调用service方法查询数据字典值

        List<DicValue> transactionTypeList = dicValueService.queryAllDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryAllDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode("source");

        Tran tran = tranService.queryTranById(id);

        //将查询结果保存到request中
        model.addAttribute("userList",userList);
        model.addAttribute("transactionTypeList",transactionTypeList);
        model.addAttribute("stageList",stageList);
        model.addAttribute("sourceList",sourceList);
        model.addAttribute("tran",tran);

        //请求转发
        return "workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/getPossibilityOfEditByStageValue.do")
    public @ResponseBody String getPossibilityOfEditByStageValue(String stageValue){
        //解析properties文件
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);
        //返回响应信息
        return possibility;
    }

    @RequestMapping("/workbench/transaction/saveEditTran.do")
    public @ResponseBody Object saveEditTran(Tran tran,HttpSession session){
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtils.formatDateTime(new Date()));

        Map<String,Object> map = new HashMap<>();
        map.put("tran",tran);
        map.put("sessionUser",user);

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service保存更新交易
            tranService.saveEditTran(map);
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

}
