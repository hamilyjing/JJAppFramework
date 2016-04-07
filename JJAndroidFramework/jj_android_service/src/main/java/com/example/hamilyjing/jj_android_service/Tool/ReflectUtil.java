package com.example.hamilyjing.jj_android_service.Tool;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Created by hamilyjing on 4/6/16.
 */
public class ReflectUtil {

    public static <T> T objectFromClassName(String className, Object... args)
    {
        T instance = null;

        if (className.isEmpty())
        {
            return instance;
        }

        try
        {
            Class clazz = Class.forName(className);
            if (args.length > 0)
            {
                Class[] types = new  Class[args.length / 2];
                Object[] paramters = new Object[args.length / 2];
                makeParameters(types, paramters, args);

                Constructor c = clazz.getConstructor(types);
                instance = (T)c.newInstance(paramters);
            }
            else
            {
                Constructor c = clazz.getConstructor();
                instance = (T)c.newInstance();
            }
        }
        catch (NullPointerException e)
        {
            e.printStackTrace();
        }
        catch (ClassNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (NoSuchMethodException e)
        {
            e.printStackTrace();
        }
        catch (IllegalAccessException e)
        {
            e.printStackTrace();
        }
        catch (InvocationTargetException e)
        {
            e.printStackTrace();
        }
        catch (InstantiationException e)
        {
            e.printStackTrace();
        }

        return instance;
    }

    public static boolean callStaticMethod(String className, String methodName, Object... args)
    {
        try
        {
            Class clazz = Class.forName(className);
            if (args.length > 0)
            {
                Class[] types = new Class[args.length / 2];
                Object[] params = new Object[args.length / 2];
                makeParameters(types, params, args);

                Method m = clazz.getMethod(methodName, types);
                m.invoke(null, params);
            }
            else
            {
                Method m = clazz.getMethod(methodName);
                m.invoke(null);
            }
            return true;

        }
        catch (ClassNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (NoSuchMethodException e)
        {
            e.printStackTrace();
        }
        catch (InvocationTargetException e)
        {
            e.printStackTrace();
        }
        catch (IllegalAccessException e)
        {
            e.printStackTrace();
        }

        return false;
    }

    private static void makeParameters(Object[] types, Object[] instances, Object[] args)
    {
        for (int i = 0; i < args.length; ++i)
        {
            if (i < args.length / 2)
            {
                types[i] = args[i];
            }
            else
            {
                instances[i - args.length / 2] = args[i];
            }
        }
    }
}
