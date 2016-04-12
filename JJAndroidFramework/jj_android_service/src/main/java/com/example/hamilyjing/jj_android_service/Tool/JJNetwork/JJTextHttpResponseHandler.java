package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import com.loopj.android.http.TextHttpResponseHandler;

import org.apache.http.Header;

/**
 * Created by hamilyjing on 4/10/16.
 */
public class JJTextHttpResponseHandler extends TextHttpResponseHandler
{
    public Integer requestIndex;

    @Override
    public void onSuccess(int i, Header[] headers, String s)
    {
        JJNetworkAgent.getInstance().onSuccess(requestIndex, i, headers, s);
    }

    @Override
    public void onFailure(int i, Header[] headers, String s, Throwable throwable)
    {
        JJNetworkAgent.getInstance().onFailure(requestIndex, i, headers, s, throwable);
    }
}
