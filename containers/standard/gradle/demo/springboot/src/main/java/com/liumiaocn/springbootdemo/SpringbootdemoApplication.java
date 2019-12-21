/* multiple comment line
   comment
   comment
*/
package com.liumiaocn.springbootdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
@SpringBootApplication
public class SpringbootdemoApplication {
        @RequestMapping("/")
        String home() {
          return "Hello, Spring Boot 2";
        }

	public static void main(String[] args) {
		SpringApplication.run(SpringbootdemoApplication.class, args);
	}
}
