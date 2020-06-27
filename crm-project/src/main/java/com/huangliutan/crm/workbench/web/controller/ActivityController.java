package com.huangliutan.crm.workbench.web.controller;

import com.huangliutan.crm.commons.constants.Constants;
import com.huangliutan.crm.commons.domain.ReturnObject;
import com.huangliutan.crm.commons.utils.DateUtils;
import com.huangliutan.crm.commons.utils.UUIDUtils;
import com.huangliutan.crm.settings.domain.User;
import com.huangliutan.crm.settings.service.UserService;
import com.huangliutan.crm.workbench.domain.Activity;
import com.huangliutan.crm.workbench.domain.ActivityRemark;
import com.huangliutan.crm.workbench.service.ActivityRemarkService;
import com.huangliutan.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(Model model) {
        //调用service层方法查询所有用户
        List<User> userList = userService.queryAllUsers();
        //将userList保存到request中
        model.addAttribute("userList", userList);
        //请求转发
        return "/workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody
    Object saveCreateActivity(Activity activity, HttpSession session) {
        //封装参数，补齐非业务数据
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        //从session中获取创建者，即是登录用户
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        activity.setCreateBy(user.getId());//设置主键值，保证唯一性

        ReturnObject returnObject = new ReturnObject();

        try {
            //调用业务层存储数据
            int ret = activityService.saveCreateActivity(activity);
            if (ret > 0) {
                //保存成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //保存失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //保存成功
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityForPageByCondition.do")
    public @ResponseBody
    Object queryActivityForPageByCondition(Integer pageNo, Integer pageSize, String name, String owner, String startDate, String endDate) {
        //封装参数，使用map集合，每次都使用实体类接收，实体类会很多，而且不是经常使用
        Map<String, Object> map = new HashMap<>();
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);

        //调用service方法分页查询市场活动
        List<Activity> activityList = activityService.queryActivityForPageByCondition(map);
        //调用service方法查询符合条件的总记录
        long totalRows = activityService.queryCountOfActivityByCondition(map);

        //根据查询结果，生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activityList);
        retMap.put("totalRows", totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/activity/editActivity.do")
    public @ResponseBody
    Object editActivity(String id) {
        //调用业务层方法查询市场活动
        Activity activity = activityService.queryActivityById(id);
        //根据查询结果，生成响应信息
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    public @ResponseBody
    Object saveEditActivity(Activity activity, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        //封装参数
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        activity.setEditTime(DateUtils.formatDateTime(new Date()));
        activity.setEditBy(user.getId());
        //调用service方法更新市场活动
        try {
            int ret = activityService.saveEditActivity(activity);
            if (ret > 0) {
                //更新成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //更新失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //更新失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        //根据处理结果，生成响应信息
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    public @ResponseBody
    Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service方法删除市场活动
            int ret = activityService.deleteActivityByIds(id);
            if (ret > 0) {
                //删除成功
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                //删除失败
                returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            //删除失败
            returnObject.setCode(Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后...");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/fileDownLoad.do")
    public void fileDownLoad(HttpServletResponse response, HttpServletRequest request) throws Exception {
        //练习浏览器发送导出文件请求

        //1.设置响应类型为文件
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.解决不同浏览器显示格式问题，可以通过请求头获取到浏览器的信息
        String browser = request.getHeader("User-Agent");
        //IE:urlencoded fireFox:ISO8859-1
        String fileName = URLEncoder.encode("学生列表", "UTF-8");
        if (browser.contains("Firefox")) {
            fileName = new String("学生列表".getBytes("UTF-8"), "ISO8859-1");
        }
        //3.默认情况下，浏览器再接收到响应信息后会直接在显示窗口打开，可以设置响应头，告诉浏览器在下载窗口显示
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");

        //4.读取服务器磁盘中学生列表文件
        InputStream is = new FileInputStream("D:\\student.xls");
        //5.将文件信息复制到输出流中
        OutputStream os = response.getOutputStream();
        //6.使用byte暂存读取的字节
        byte[] buff = new byte[256];
        int len = 0;
        //7.写入输出流中，实际上在这里是写到浏览器的意思
        while ((len = is.read(buff)) != -1) {
            os.write(buff, 0, len);
        }
        //8.关闭资源
        os.flush();
        is.close();
    }

    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //调用业务层方法查询所有的市场活动
        List<Activity> activityList = activityService.queryAllActivityForDetail();

        //创建HSSFWorkbook对象，对应的一个excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //使用wb创建HSSFSheet对象，对应的excel中的一页
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        //使用wb创建HSSFCellStyle对象，指定列的样式
        HSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        //使用sheet创建HSSFRow对象，对应的excel中的一行,0表示第一行
        HSSFRow row = sheet.createRow(0);
        //使用row创建的HSSFCell对象，对应的一行中的一列，0表示第一列,1...
        HSSFCell cell = row.createCell(0);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("创建者");
        cell = row.createCell(8);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("创建时间");
        cell = row.createCell(9);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("修改者");
        cell = row.createCell(10);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("修改时间");

        //先判断集合是否为空，不能一上来就遍历
        if (activityList != null) {
            //优化提高效率
            Activity activity = null;
            //遍历集合，保存到文件中
            for (int i = 0; i < activityList.size(); i++) {
                row = sheet.createRow(i + 1);//从第二行开始
                activity = activityList.get(i);

                cell = row.createCell(0);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(8);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(9);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getEditBy());
                cell = row.createCell(10);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getEditTime());
            }
        }

        //设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //获取请求头中浏览器的信息
        String browser = request.getHeader("User-Agent");
        //System.out.println("browser-------------->"+browser);
        //不同浏览器接收响应头采用的编码格式都不一样
        //IE使用的urlencoded
        //FireFox使用的ISO8859-1
        String fileName = URLEncoder.encode("市场活动列表", "UTF-8");
        if (browser.contains("Firefox")) {
            fileName = new String("市场活动列表".getBytes("UTF-8"), "ISO8859-1");
        }
        //默认情况下，浏览器接收到响应信息之后直接会在显示窗口打开，可以设置响应头信息，使浏览器在接收到信息时在下载窗口打开
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");

        //获取文件输出流
        OutputStream os = response.getOutputStream();

        //输出信息到浏览器
        wb.write(os);
        os.flush();

        //关闭资源
        wb.close();
    }

    @RequestMapping("/workbench/activity/exportActivitySelective.do")
    public void exportActivitySelective(String[] id, HttpServletResponse response, HttpServletRequest request) throws IOException {

        //1.设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.根据http协议，浏览器在访问服务器时，会通过请求头携带浏览器信息发送到服务器
        String browser = request.getHeader("User-Agent");
        //不同的浏览器接收响应头的编码方式不一样
        //IE:urlencoded FireFox:ISO8859-1
        String fileName = URLEncoder.encode("市场活动列表", "UTF-8");
        if (browser.contains("Firefox")) {
            fileName = new String("市场活动列表".getBytes("UTF-8"), "ISO-8859-1");
        }
        //3.浏览器默认情况下会在接收到响应信息时在显示窗口直接显示，通过设置响应头信息告诉浏览器在文件下载窗口显示
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName + ".xls");

        //4.调用业务层方法查询市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByIds(id);
        //5.获取字节输出流
        OutputStream os = response.getOutputStream();

        //创建HSSFWorkbook对象，对应的是excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //通过wb创建HSSFSheet对象，对应excel文件中的一页
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        //通过sheet创建HSSFRow对象，对应excel一页中的一行,从0开始依次递增，0表示第一行
        HSSFRow row = sheet.createRow(0);
        //通过wb创建HSSFCellStyle列样式
        HSSFCellStyle cellStyle = wb.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        //通过row创建HSSFCell对象，对应excel一行中的一列，以0开始依次递增，0表示第一列
        HSSFCell cell = row.createCell(0);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("创建者");
        cell = row.createCell(8);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("创建时间");
        cell = row.createCell(9);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("修改者");
        cell = row.createCell(10);
        cell.setCellStyle(cellStyle);
        cell.setCellValue("修改时间");

        //判断集合是否为空，不为空则遍历
        if (activityList != null) {
            //提高效率
            Activity activity = null;
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);
                //从第二行开始
                row = sheet.createRow(i + 1);

                cell = row.createCell(0);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(8);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(9);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getEditBy());
                cell = row.createCell(10);
                cell.setCellStyle(cellStyle);
                cell.setCellValue(activity.getEditTime());
            }
        }

        //响应信息
        wb.write(os);
        os.flush();

        //关闭资源
        wb.close();
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    public @ResponseBody
    Object importActivity(MultipartFile activityFile, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SessionParam.SESSION_USER);
        Map<String, Object> retMap = new HashMap<>();
        try {
            //创建list集合
            List<Activity> activityList = new ArrayList<>();
            Activity activity = null;
            //通过MultipartFile获取输入流对象，流中携带浏览器文件的二进制信息
            InputStream inputStream = activityFile.getInputStream();
            //创建HSSFWorkbook对象，保存目标对象中的数据
            HSSFWorkbook wb = new HSSFWorkbook(inputStream);
            //通过wb创建HSSFSheet对象，解析excel文件中的一页
            HSSFSheet sheet = wb.getSheetAt(0);

            HSSFRow row = null;
            HSSFCell cell = null;
            //遍历excel文件中的行和列,第一行数据不需要存储
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {//sheet.getLastRowNum(),获取到最后一行
                row = sheet.getRow(i);
                //读一行创建一个Activity对象
                activity = new Activity();

                //ID，这种字段客户不会输入的由程序员设值
                activity.setId(UUIDUtils.getUUID());
                //所有者全部设值为当前用户，然后再分配任务
                activity.setOwner(user.getId());
                //创建者肯定是当前用户
                activity.setCreateBy(user.getId());
                //创建时间就是上传的时间，当前时间
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));

                for (int j = 0; j < row.getLastCellNum(); j++) {//row.getLastCellNum(),获取到最后一行+1
                    cell = row.getCell(j);
                    String cellValue = getCellValue(cell);
                    //判断cell不为空,就不用进去判断，提高效率
                    if (cellValue != "") {
                        if (j == 0) {
                            activity.setName(getCellValue(cell));
                        } else if (j == 1) {
                            activity.setStartDate(getCellValue(cell));
                        } else if (j == 2) {
                            activity.setEndDate(getCellValue(cell));
                        } else if (j == 3) {
                            activity.setCost(getCellValue(cell));
                        } else if (j == 4) {
                            activity.setDescription(getCellValue(cell));
                        }
                    }
                }
                //遍历一行添加到集合前，如果不判断，发现单元格输入值后删掉，是空行还是会上传,所以可以判断名称不为null和“”，就添加
               /* if(activity.getName() != null && activity.getName() != ""){
                    activityList.add(activity);
                }*/
                //虽然上面的方法好，但是不符合需求文档的要求，那么我们判断行的所有列中有一列不为空，就上传
                if (activity.getName() != null || activity.getStartDate() != null || activity.getEndDate() != null || activity.getCost() != null || activity.getDescription() != null) {
                    activityList.add(activity);
                }
            }
            //调用业务层方法保存数据
            int retInt = activityService.saveCreateActivityByList(activityList);
            //这里不发生异常就表示上传成功
            retMap.put("code", Constants.ReturnObjectCode.RETURN_OBJECT_CODE_SUCCESS);
            retMap.put("count", retInt);
        } catch (IOException e) {
            e.printStackTrace();
            //上传失败
            retMap.put("code", Constants.ReturnObjectCode.RETURN_OBJECT_CODE_FAIL);
            retMap.put("message", "系统忙，请稍后重试...");
        }
        return retMap;
    }

    /**
     * 获取单元格中的值
     *
     * @return 返回字符串类型的数据
     */
    public static String getCellValue(HSSFCell cell) {
        String ret = "";
        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_STRING:
                ret = cell.getStringCellValue();
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                ret = cell.getBooleanCellValue() + "";
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                ret = cell.getNumericCellValue() + "";
                break;
            case HSSFCell.CELL_TYPE_FORMULA:
                ret = cell.getCellFormula();
                break;
            default:
                ret = "";
        }
        return ret;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,Model model){
        //调用业务层方法查询市场活动明细和备注
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);

        //将查询结果保存到request中，底层实际上是保存到一个map中
        model.addAttribute("activity",activity);
        model.addAttribute("activityRemarkList",activityRemarkList);

        //请求转发
        return "workbench/activity/detail";
    }

}
