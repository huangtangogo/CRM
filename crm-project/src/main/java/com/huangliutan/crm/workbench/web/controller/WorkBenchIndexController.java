package com.huangliutan.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkBenchIndexController {

    /**
     * 该方法用于跳转到workbench工作台首页
     * @return 逻辑路径
     */
    @RequestMapping("/workbench/index.do")
    public String toWorkBenchIndex(){
        return "workbench/index";
    }
}
