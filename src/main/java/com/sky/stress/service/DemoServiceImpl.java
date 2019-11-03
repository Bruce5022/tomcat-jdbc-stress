package com.sky.stress.service;

import com.sky.stress.model.RequestBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Transactional
@Service
public class DemoServiceImpl implements DemoService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public List<Map<String, Object>> getSettleParam() {
        return jdbcTemplate.queryForList("select * from Cs_Parameter");
    }

    @Override
    public int updateSettleParam(RequestBean param) throws Exception {
        int result = jdbcTemplate.update("update Cs_Parameter set updateBy=" + param.getUpdateBy() + " where id=\'" + param.getId() + "\'");

        TimeUnit.SECONDS.sleep(1);
        int i = 10 / param.getNum();

        return result;
    }
}
