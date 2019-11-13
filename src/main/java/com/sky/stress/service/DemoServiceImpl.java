package com.sky.stress.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sky.stress.model.RequestBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;
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

    @Override
    public String getBusiCode(RequestBean param) throws Exception {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String thisDate = dateFormat.format(new Date());


        String select_sql = "select * from bill_code_rule where busidate='" + thisDate + "' and busi_code='" + param.getBusiCode() + "'";
        String insert_sql = "insert into bill_code_rule(id,busi_code,current_val,pattern,busidate,num_len) values ('" + UUID.randomUUID().toString() + "','" + param.getBusiCode() + "',1,'yyyyMMdd'," + thisDate + ",4);";
        String update_sql = "update bill_code_rule set current_val=current_val+1" + " where busidate='" + thisDate + "' and busi_code='" + param.getBusiCode() + "'";

        int result = jdbcTemplate.update(update_sql);
        if (result == 0) {
            jdbcTemplate.update(insert_sql);
        }
        List<Map<String, Object>> maps = jdbcTemplate.queryForList(select_sql);

        Map<String, Object> map = maps.get(0);
        String busi_code = (String) map.get("busi_code");
        int len = (Integer) map.get("num_len");
        String current_val = map.get("current_val") + "";
        StringBuffer code = new StringBuffer();
        code.append(busi_code);
        code.append(thisDate);
        for (int i = 0; i < len - current_val.length(); i++) {
            code.append("0");
        }
        code.append(current_val);
        return code.toString();
    }
}
