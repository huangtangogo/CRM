package com.huangliutan.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 定义工具类用来指定日期格式
 */
public class DateUtils {
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//HH 就是24小时制的
        String str = sdf.format(date);
        return str;
    }
}
