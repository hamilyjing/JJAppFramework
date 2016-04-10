package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import com.alibaba.fastjson.JSON;
import com.loopj.android.http.TextHttpResponseHandler;

import org.apache.http.Header;

class JJResult
{
    String errNum;
    String errMsg;
}

/**
 * Created by hamilyjing on 4/10/16.
 */
public class JJTextHttpResponseHandler extends TextHttpResponseHandler
{
    public JJBaseRequest request;

    @Override
    public void onSuccess(int i, Header[] headers, String s)
    {
        JJResult result = JSON.parseObject(s, JJResult.class);
        JJNetworkAgent.getInstance().onSuccess(request, i, headers, s);
    }

    @Override
    public void onFailure(int i, Header[] headers, String s, Throwable throwable)
    {
        JJNetworkAgent.getInstance().onFailure(request, i, headers, s, throwable);
    }
}
