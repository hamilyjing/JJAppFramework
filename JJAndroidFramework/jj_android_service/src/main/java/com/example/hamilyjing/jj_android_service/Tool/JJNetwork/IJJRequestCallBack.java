package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

/**
 * Created by hamilyjing on 4/11/16.
 */
public interface IJJRequestCallBack
{
    void onSuccess(JJBaseRequest request);

    void onFailure(JJBaseRequest request);
}
