package com.huangliutan.crm.poi;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.FileOutputStream;
import java.io.OutputStream;

public class Student {
    public static void main(String[] args) throws Exception {
        //1.创建SHHFWorkbook对象，对应excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //2.使用wb创建HSSFSheet对象，对应excel文件的一页
        HSSFSheet sheet = wb.createSheet("学生信息列表");
        //3.使用sheet创建HSSFRow对象，对应excel文件一页中的一行,从0开始
        HSSFRow row = sheet.createRow(0);
        //4.使用wb创建单元格样式HSSFCellStyle对象,居中设置
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);

        //5.使用row创建HSSFCell对象，对应excel文件中的当前页当前行的单元格,从0开始
        //第一个单元格 A1
        HSSFCell cell = row.createCell(0);
        //使用样式
        cell.setCellStyle(style);
        //设值
        cell.setCellValue("学生姓名");

        //B1
        cell = row.createCell(1);
        cell.setCellStyle(style);
        cell.setCellValue("年龄");

        //其他行
        for(int i =1;i<6;i++){
            row = sheet.createRow(i);

            cell = row.createCell(0);
            cell.setCellStyle(style);
            cell.setCellValue("张三"+i);

            cell = row.createCell(1);
            cell.setCellStyle(style);
            cell.setCellValue(20+i);
        }

        //创建字节输出流对象
        OutputStream os = new FileOutputStream("D:\\student.xls");

        //使用wb生成excel文件
        wb.write(os);
        os.flush();
        os.close();
        wb.close();
        System.out.println("============export excel ok===============");
    }
}
