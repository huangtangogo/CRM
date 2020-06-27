package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.DicValue;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.settings.service.DicValueService;
import com.huangliutan.crm.settings.service.UserService;
import com.huangliutan.crm.workbench.domain.Activity;
import com.huangliutan.crm.workbench.domain.Clue;
import com.huangliutan.crm.workbench.domain.ClueActivityRelation;
import com.huangliutan.crm.workbench.domain.ClueRemark;
import com.huangliutan.crm.workbench.service.ActivityService;
import com.huangliutan.crm.workbench.service.ClueActivityRelationService;
import com.huangliutan.crm.workbench.service.ClueRemarkService;
import com.huangliutan.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import sun.tools.jconsole.inspector.XObject;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(Model model) {
        //调用业务层方法查询所有的用户
        List<User> userList = userService.queryAllUsers();
        String typeCode = "";
        //调用业务层方法查询所有的称呼，因为是程序员创建的，开发时可以直接使用
        typeCode = "appellation";
        List<DicValue> appellationList = dicValueService.queryAllDicValueByTypeCode(typeCode);
        //调用业务层放法查询所有的线索来源
        typeCode = "source";
        List<DicValue> sourceList = dicValueService.queryAllDicValueByTypeCode(typeCode);
        //调用所有业务层方法查询所有的线索状态
        typeCode = "clueState";
        List<DicValue> clueStateList = dicValueService.queryAllDicValueByTypeCode(typeCode);

        //将结果保存的request中
        model.addAttribute("userList", userList);
        model.addAttribute("appellationList", appellationList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("clueStateList", clueStateList);

        //请求转发
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public @ResponseBody
    Object saveCreateClue(Clue clue, HttpSession session) {
        //获取用户信息
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用业务层方法保存线索
            int ret = clueService.saveCreateClue(clue);
            if (ret > 0) {
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueForPageByCondition.do")
    public @ResponseBody
    Object queryClueForPageByCondition(String fullName, String company, String phone, String source, String owner, String mphone, String state, Integer pageNo, Integer pageSize) {
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("fullName", fullName);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        //调用service方法查询线索
        List<Clue> clueList = clueService.queryClueForPageByCondition(map);
        long totalRows = clueService.queryCountForPageByCondition(map);

        //生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("clueList", clueList);
        retMap.put("totalRows", totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    public @ResponseBody
    Object deleteClueByIds(String[] id) {
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用业务层方法删除线索
            int ret = clueService.deleteClueByIds(id);
            if (ret > 0) {
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    public @ResponseBody
    Object queryClueById(String id) {
        //调用业务层方法查询线索
        Clue clue = clueService.queryClueById(id);
        //根据查询结果，返回响应信息
        return clue;
    }

    @RequestMapping("/workbench/clue/saveEditClue.do")
    public @ResponseBody Object saveEditClue(Clue clue, HttpSession session) {
        //获取当前用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        //封装参数
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用业务层方法更新数据
            int ret = clueService.saveEditClue(clue);
            if (ret > 0) {
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueForDetail.do")
    public String queryClueForDetail(String id,Model model){
        //调用业务层方法查询数据
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> remarkList = clueRemarkService.queryClueRemarkByClueId(id);
        List<Activity> activityList = activityService.queryAllRelationActivityByClueId(id);

        //将查询结果保存到request中
        model.addAttribute("clue",clue);
        model.addAttribute("remarkList",remarkList);
        model.addAttribute("activityList",activityList);

        //请求转发
        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
    public @ResponseBody Object queryActivityForDetailByNameClueId(String activityName,String clueId){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);

        //调用service查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);

        //返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/clue/saveBundActivity.do")
    public @ResponseBody Object saveBundActivity(String[] activityId,String clueId){
        //封装参数
        ClueActivityRelation clueActivityRelation = null;
        List<ClueActivityRelation> relationList = new ArrayList<>();
        for(String al:activityId){
            clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtils.getUUID());
            clueActivityRelation.setClueId(clueId);
            clueActivityRelation.setActivityId(al);
            relationList.add(clueActivityRelation);
        }
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法保存线索关联市场活动
            int ret = clueActivityRelationService.saveCreateClueActivityRelationByList(relationList);
            if(ret>0){
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
                //调用service方法批量查询市场活动
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            }else{
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            //保存失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/removeClueActivityRelation.do")
    public @ResponseBody Object removeClueActivityRelation(ClueActivityRelation clueActivityRelation){
        //创建响应对象
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service方法解除线索关联市场活动
            int ret = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(clueActivityRelation);
            if(ret>0){
                //解除成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                //解除失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch(Exception e){
            //解除失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/convert.do")
    public String convert(String id,Model model){
        //调用service方法查询数据
        Clue clue = clueService.queryClueForDetailById(id);
        List<DicValue> stageList = dicValueService.queryAllDicValueByTypeCode("stage");
        //将查询结果保存到request中
        model.addAttribute("clue",clue);
        model.addAttribute("stageList",stageList);
        //请求转发
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByName.do")
    public @ResponseBody Object queryActivityForDetailByName(String name){
        //调用service方法查询数据
        List<Activity> activityList = activityService.queryActivityForDetailByName(name);
        //返回响应数据
        return activityList;
    }

    @RequestMapping("/workbench/clue/saveClueConvert.do")
    public @ResponseBody Object saveClueConvert(String clueId,String isCreateTran,String money,String name,String expectedDate,String stage,String activityId,HttpSession session){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("isCreateTran",isCreateTran);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        map.put("user",user);

        //创建响应对象
        ReturnObject returnObject = new ReturnObject();

        try {
            //调用service方法转换线索
            clueService.saveConvert(map);
            //根据是否出现异常判断响应结果
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
        }catch(Exception e){
            e.printStackTrace();
            //转换失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }
}
