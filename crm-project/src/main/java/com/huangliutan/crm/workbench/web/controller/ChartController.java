package com.huangliutan.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChartController {

    @RequestMapping("/workbench/chart/transaction/index.do")
    public String index(){
        //页面跳转
        return "workbench/chart/transaction/index";
    }
}
