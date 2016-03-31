package com.example.hamilyjing.jj_android_service.ServiceFactory;

import java.util.HashMap;

/**
 * Created by hamilyjing on 3/31/16.
 */
public class JJServiceFactory
{
    private static JJServiceFactory instance = new JJServiceFactory();

    private HashMap<String, JJService> serviceHashMap = new HashMap<>();

    public static JJServiceFactory getInstance()
    {
        return instance;
    }

    private JJServiceFactory()
    {

    }

    JJService getService(String serviceName)
    {
        Object service = Class.forName(serviceName).newInstance();
        return (JJService)service;
    }


}
