package com.example.hamilyjing.jj_android_service.ServiceFactory;

import com.example.hamilyjing.jj_android_service.Tool.ReflectUtil;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

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

    public JJService getService(String serviceName)
    {
        JJService service = serviceHashMap.get(serviceName);
        if (service != null)
        {
            return service;
        }

        service = ReflectUtil.objectFromClassName(serviceName);

        service.serviceWillLoad();
        serviceHashMap.put(serviceName, service);
        service.serviceDidLoad();

        return service;
    }

    public void unloadService(String serviceName, boolean isForceUnload)
    {
        JJService service = serviceHashMap.get(serviceName);
        if (null == service)
        {
            return;
        }

        if (!isForceUnload && !service.needUnloading())
        {
            return;
        }

        service.serviceWillUnload();
        serviceHashMap.remove(serviceName);
        service.serviceDidUnload();
    }

    public void unloadService(String serviceName)
    {
        unloadService(serviceName, false);
    }

    private void unloadUnneededService()
    {
        Iterator iterator = serviceHashMap.entrySet().iterator();
        while (iterator.hasNext())
        {
            Map.Entry entry = (Map.Entry)iterator.next();
            String className = (String)entry.getKey();
            JJService service = (JJService)entry.getValue();

            if (service.needUnloading())
            {
                iterator.remove();
                //serviceHashMap.remove(className);
            }
        }
    }
}
