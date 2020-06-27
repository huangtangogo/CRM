package com.huangliutan.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {

    public static String getUUID(){
        //使用UUID算法获取随机32位字符串
       return UUID.randomUUID().toString().replaceAll("-","");
    }
}
