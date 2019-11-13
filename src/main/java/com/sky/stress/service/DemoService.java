package com.sky.stress.service;

import com.sky.stress.model.RequestBean;

import java.util.List;
import java.util.Map;

public interface DemoService {

    List<Map<String, Object>> getSettleParam();

    int updateSettleParam(RequestBean param) throws Exception;

    String getBusiCode(RequestBean param) throws Exception;
}
