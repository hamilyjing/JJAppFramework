package com.example.hamilyjing.jj_android_service.ServiceFactory;

import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJRequest;
import com.example.hamilyjing.jj_android_service.Tool.Model.JJBaseResponseModel;
import com.example.hamilyjing.jj_android_service.Tool.ReflectUtil;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by hamilyjing on 3/31/16.
 */
public class JJService {

    private HashMap<String, JJFeatureSet> featureSetHashMap = new HashMap<>();

    private Integer requestFinishCount = 0;

    public static String serviceName()
    {
        return null;
    }

    public void serviceWillLoad()
    {

    }

    public void serviceDidLoad()
    {

    }

    public void serviceWillUnload()
    {

    }

    public void serviceDidUnload()
    {

    }

    public boolean needUnloading()
    {
        return false;
    }

    public void recordRequestFinishCount(Integer count) {
        synchronized(this)
        {
            this.requestFinishCount = this.requestFinishCount + count;
        }
    }

    public void callBack(Context context, boolean success, JJRequest request, Object otherInfo, IJJServiceCallBack serviceCallBack)
    {
        if (success)
        {
            Object model = request.currentResponseModel();
            serviceCallBack.onNetworkRequestSuccess(model, request.getResponseString(), otherInfo);
        }
        else
        {
            serviceCallBack.onNetworkRequestFailure(request.getResponseCode(), request.getResponseString(), otherInfo);
        }

        sendBroadcast(context, success, request, otherInfo);

        recordRequestFinishCount(1);
    }

    public void sendBroadcast(Context context, boolean success, JJRequest request, Object otherInfo)
    {
        Intent intent = new Intent();

        intent.putExtra("success", success);
        intent.putExtra("responseString", request.getResponseString());

        Bundle bundle = new Bundle();
        bundle.putSerializable("otherInfo", (Serializable)otherInfo);

        if (success)
        {
            Object model = request.currentResponseModel();
            bundle.putSerializable("model", (Serializable)model);
        }
        else
        {
            intent.putExtra("responseCode", request.getResponseCode());
        }

        context.sendBroadcast(intent);
    }

    /// feature set

    public JJFeatureSet getFeatureSet(String featureSetName)
    {
        JJFeatureSet featureSet = featureSetHashMap.get(featureSetName);
        if (featureSet != null)
        {
            return featureSet;
        }

        featureSet = ReflectUtil.objectFromClassName(featureSetName);
        if (null == featureSet)
        {
            return null;
        }

        featureSet.setService(this);

        featureSet.featureSetWillLoad();
        featureSetHashMap.put(featureSetName, featureSet);
        featureSet.featureSetDidLoad();

        return featureSet;
    }

    public void unloadFeatureSet(String featureSetName, boolean isForceUnload)
    {
        JJFeatureSet featureSet = featureSetHashMap.get(featureSetName);
        if (null == featureSet)
        {
            return;
        }

        if (!isForceUnload && !featureSet.needUnloading())
        {
            return;
        }

        featureSet.featureSetWillUnload();
        featureSetHashMap.remove(featureSetName);
        featureSet.featureSetDidUnload();
    }
}
