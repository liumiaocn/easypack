package com.liumiaocn;

public class HelloPlugin {
    private final String pluginName;

    public HelloPlugin(String name) {
        this.pluginName= name;
    }

    public void grettings() {
      System.out.println("Hello, " + this.pluginName);
    } 
}
