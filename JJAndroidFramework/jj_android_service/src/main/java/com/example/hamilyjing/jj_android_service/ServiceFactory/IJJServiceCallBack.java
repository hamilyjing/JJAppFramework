package com.example.hamilyjing.jj_android_service.ServiceFactory;

import android.content.Context;

/**
 * Created by hamilyjing on 4/11/16.
 */
public interface IJJServiceCallBack
{
    void onNetworkRequestSuccess(Object model, String responseString, Object otherInfo);

    void onNetworkRequestFailure(int code, String responseString, Object otherInfo);
}
