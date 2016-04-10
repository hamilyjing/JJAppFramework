package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

/**
 * Created by hamilyjing on 4/9/16.
 */
public class JJBaseRequest {

    enum JJRequestMethod
    {
        JJRequestMethodGet,
        JJRequestMethodPost,
        JJRequestMethodHead,
        JJRequestMethodPut,
        JJRequestMethodDelete,
        JJRequestMethodPatch
    }

    public JJRequestMethod requestMethod = JJRequestMethod.JJRequestMethodGet;

    public Integer timeoutInterval = 10;

    public Integer index;

    public JJBaseRequest()
    {
    }

    public boolean useCDN()
    {
        return false;
    }

    public String cdnUrl()
    {
        return "";
    }

    public String baseUrl()
    {
        return "";
    }

    public String requestUrl()
    {
        return "";
    }

    public String requestArgument()
    {
        return "";
    }
}
