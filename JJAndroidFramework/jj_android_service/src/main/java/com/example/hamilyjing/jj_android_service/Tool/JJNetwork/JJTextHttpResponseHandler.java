package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import com.alibaba.fastjson.JSON;
import com.loopj.android.http.TextHttpResponseHandler;

import org.apache.http.Header;
import org.json.JSONObject;

//class JJResult
//{
//    Long errNum;
//    String errMsg;
//
//    public Long getErrNum() {
//        return errNum;
//    }
//
//    public void setErrNum(Long errNum) {
//        this.errNum = errNum;
//    }
//
//    public String getErrMsg() {
//        return errMsg;
//    }
//
//    public void setErrMsg(String errMsg) {
//        this.errMsg = errMsg;
//    }
//
//    public void parseJson(JSONObject json)
//    {
//        if (json != null)
//        {
//            this.errNum = json.optLong("errNum");
//            this.errMsg = json.optString("errMsg");
//        }
//    }
//}

/**
 * Created by hamilyjing on 4/10/16.
 */
public class JJTextHttpResponseHandler extends TextHttpResponseHandler
{
    public Integer requestIndex;

    @Override
    public void onSuccess(int i, Header[] headers, String s)
    {
//        JJResult result = JSON.parseObject(s, JJResult.class);
        JJNetworkAgent.getInstance().onSuccess(requestIndex, i, headers, s);
    }

    @Override
    public void onFailure(int i, Header[] headers, String s, Throwable throwable)
    {
        JJNetworkAgent.getInstance().onFailure(requestIndex, i, headers, s, throwable);
    }
}
