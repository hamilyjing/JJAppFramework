package com.example.hamilyjing.jj_android_service.ServiceFactory;

import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJBaseResponseModel;

/**
 * Created by hamilyjing on 4/11/16.
 */
public interface IJJServiceCallBack
{
    void onSuccess(JJBaseResponseModel model, String responseString, Object otherInfo);

    void onFailure(int code, String responseString, Object otherInfo);
}
