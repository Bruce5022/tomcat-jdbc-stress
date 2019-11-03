package com.sky.stress;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.junit4.SpringRunner;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ApplicationTests {
    @Autowired
    private DataSource dataSource;

    @Test
    public void testDataSource() {
        System.out.println("--->" + dataSource.getClass());
    }


    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    public void testJdbc() {

        List<Map<String, Object>> maps = jdbcTemplate.queryForList("select * from Cs_Parameter");
        for (Map<String, Object> map : maps) {
            System.err.println(map);
        }
    }


    @Test
    public void testBatchJdbc() {

//        for (int i = 0; i < 2; i++) {
//            new Thread(() -> {
                List<Map<String, Object>> maps = jdbcTemplate.queryForList("select * from Cs_Parameter");
                for (Map<String, Object> map : maps) {
                    System.err.println(map);
                }
//            }).start();
//        }
    }
}