package com.huangliutan.crm.poi;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

public class ParseExcelTest {
    public static void main(String[] args) throws IOException {
        //创建字节输入流读取磁盘中文件
        InputStream is = new FileInputStream("D:\\student.xls");
        //创建HSSFWorkbook，风中文件中的所有数据
        HSSFWorkbook wb = new HSSFWorkbook(is);
        //根据wb创建HSSFSheet对象，对应excel中的一页数据
        HSSFSheet sheet = wb.getSheetAt(0);
        HSSFRow row = null;
        HSSFCell cell = null;
        //因为表中有很多行，因此需要遍历
        for(int i = 0; i <= sheet.getLastRowNum();i++){// sheet.getLastRowNum()获取最后一行的编号
            row = sheet.getRow(i);
            //行中有很多列
            for(int j = 0 ;j < row.getLastCellNum();j++){//row.getLastCellNum()获取最后一行+1的编号
                cell = row.getCell(j);
                //直接打印每列中的信息
                System.out.print(getCellValue(cell)+" ");
            }
            System.out.println();
        }
    }

    //涉及到多个数据，使用方法封装，全部响应String类型
    public static String getCellValue(HSSFCell cell){
        String ret = "";
       switch(cell.getCellType()){
           case HSSFCell.CELL_TYPE_STRING:
               ret = cell.getStringCellValue();
               break;
           case HSSFCell.CELL_TYPE_NUMERIC:
               ret = cell.getNumericCellValue()+"";
               break;
           case HSSFCell.CELL_TYPE_BOOLEAN:
               ret = cell.getBooleanCellValue()+"";
               break;
           case HSSFCell.CELL_TYPE_FORMULA:
               ret = cell.getCellFormula();
               break;
           default:
               ret = "";
       }
       return  ret;
    }
}
