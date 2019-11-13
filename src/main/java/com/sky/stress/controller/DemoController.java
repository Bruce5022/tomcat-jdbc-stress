package com.sky.stress.controller;

import com.sky.stress.model.RequestBean;
import com.sky.stress.service.DemoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping(value = "/demo")
public class DemoController {
    private static int count = 0;

    @Autowired
    private DemoService demoService;

    @GetMapping(value = "/settleParamList", produces = {"application/json;charset=UTF-8"})
    public Object settleParamList() throws Exception {
        TimeUnit.SECONDS.sleep(1);
        List<Map<String, Object>> settleParam = demoService.getSettleParam();
        System.out.println("第" + (count++) + "次请求结果:" + settleParam);
        return settleParam;
    }

    @PostMapping(value = "/updateParam", produces = "application/json;charset=UTF-8")
    public Object updateParam(@RequestBody RequestBean param) throws Exception {
        int result = demoService.updateSettleParam(param);
        System.out.println("请求参数:" + param + ",结果:" + result);
        return result;
    }

    @PostMapping(value = "/getCode", produces = "application/json;charset=UTF-8")
    public Object getBusiCode(@RequestBody RequestBean param) throws Exception {
        String result = demoService.getBusiCode(param);
        System.out.println("请求参数:" + param + ",结果:" + result);
        return result;
    }
}
