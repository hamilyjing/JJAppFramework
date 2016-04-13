package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import android.support.annotation.NonNull;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

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

    private Integer timeoutInterval = 60;
    private JJRequestMethod requestMethod = JJRequestMethod.JJRequestMethodGet;
    private Integer requestIndex;
    private IJJRequestCallBack requestCallBack;

    private boolean isNetworkResponseSuccess;
    private Integer responseCode;
    private String responseString;

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

    public Map<String, String> requestArgument()
    {
        return null;
    }

    public void requestCompleteFilter()
    {
    }

    public void requestFailedFilter()
    {
    }

    public void start()
    {
        JJNetworkAgent.getInstance().addRequest(this);
    }

    public void startWithCallBack(IJJRequestCallBack callBack)
    {
        this.requestCallBack = callBack;
        start();
    }

    public void stop()
    {
        JJNetworkAgent.getInstance().cancelRequest(this);
    }

    /// get and set

    public JJRequestMethod getRequestMethod() {
        return requestMethod;
    }

    public void setRequestMethod(JJRequestMethod requestMethod) {
        this.requestMethod = requestMethod;
    }

    public Integer getTimeoutInterval() {
        return timeoutInterval;
    }

    public void setTimeoutInterval(Integer timeoutInterval) {
        this.timeoutInterval = timeoutInterval;
    }

    public Integer getRequestIndex() {
        return requestIndex;
    }

    public void setRequestIndex(Integer requestIndex) {
        this.requestIndex = requestIndex;
    }

    public IJJRequestCallBack getRequestCallBack() {
        return requestCallBack;
    }

    public void setRequestCallBack(IJJRequestCallBack requestCallBack) {
        this.requestCallBack = requestCallBack;
    }

    public boolean isNetworkResponseSuccess() {
        return isNetworkResponseSuccess;
    }

    public void setIsNetworkResponseSuccess(boolean isNetworkResponseSuccess) {
        this.isNetworkResponseSuccess = isNetworkResponseSuccess;
    }

    public Integer getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(Integer responseCode) {
        this.responseCode = responseCode;
    }

    public String getResponseString() {
        return responseString;
    }

    public void setResponseString(String responseString) {
        this.responseString = responseString;
    }
}
