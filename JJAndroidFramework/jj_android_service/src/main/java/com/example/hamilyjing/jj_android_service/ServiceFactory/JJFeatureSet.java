package com.example.hamilyjing.jj_android_service.ServiceFactory;

import android.content.Context;

import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.IJJRequestCallBack;
import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJBaseRequest;
import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJRequest;

/**
 * Created by JJ on 4/13/16.
 */
public class JJFeatureSet {

    private JJService service;

    public static String featureSetName()
    {
        return null;
    }

    public void featureSetWillLoad()
    {

    }

    public void featureSetDidLoad()
    {

    }

    public void featureSetWillUnload()
    {

    }

    public void featureSetDidUnload()
    {

    }

    public boolean needUnloading()
    {
        return false;
    }

    public void startRequst(final Context context, JJRequest request, final IJJServiceCallBack serviceCallBack)
    {
        getService().recordRequestFinishCount(-1);

        request.startWithCallBack(new IJJRequestCallBack() {
            @Override
            public void onSuccess(JJBaseRequest request) {
                getService().callBack(context, true, (JJRequest) request, null, serviceCallBack);
            }

            @Override
            public void onFailure(JJBaseRequest request) {
                getService().callBack(context, false, (JJRequest) request, null, serviceCallBack);
            }
        });
    }

    public JJService getService() {
        return service;
    }

    public void setService(JJService service) {
        this.service = service;
    }
}
