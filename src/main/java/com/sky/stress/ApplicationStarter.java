package com.sky.stress;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Hello world!
 */
@SpringBootApplication
public class ApplicationStarter {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        SpringApplication.run(ApplicationStarter.class, args);
    }
}
