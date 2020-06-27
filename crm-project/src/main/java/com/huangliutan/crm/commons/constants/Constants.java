package com.huangliutan.crm.commons.constants;

/**
 * 自定义常量类，用于声明多处使用到的常量值名称，使用静态内部类进行分类
 */
public class Constants {

    //验证登录用户结果code
    public static class ReturnObjectCode{
        public static final String RETURN_OBJECT_CODE_SUCCESS = "1";
        public static final String RETURN_OBJECT_CODE_FAIL = "0";
    }

    //HttpSession携带用户的参数名称
    public static class SessionParam{
        public static final String SESSION_USER = "sessionUser";
    }
}
