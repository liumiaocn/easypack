package com.liumiao.controller;
 
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HelloController {
 
	private static final String VIEW_INDEX = "index";
	private final static Logger logger = LoggerFactory.getLogger(HelloController.class);
 
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String welcome(ModelMap model) {
 
		model.addAttribute("message", "");
		logger.debug("[hello]");
 
		return VIEW_INDEX;
 
	}
 
	@RequestMapping(value = "/{name}", method = RequestMethod.GET)
	public String greetingMessage(@PathVariable String name, ModelMap model) {
 
		model.addAttribute("message", "Hello " + name);
		logger.debug("[helloName] name : {}", name);
		return VIEW_INDEX;
 
	}
 
}
