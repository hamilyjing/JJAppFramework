package com.example.hamilyjing.jj_android_service.Tool.Model;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import java.io.Serializable;

/**
 * Created by hamilyjing on 4/11/16.
 */
public class JJBaseResponseModel implements Serializable, IResponseModel
{
    private static final long serialVersionUID = 1;

    private String responseResultString;
    private JSONArray responseResultList;

    @Override
    public boolean successForBussiness(Object model) {
        return true;
    }

    @Override
    public void setData(JSONObject jsonObject) {

    }

    public String getResponseResultString() {
        return responseResultString;
    }

    public void setResponseResultString(String responseResultString) {
        this.responseResultString = responseResultString;
    }

    public JSONArray getJsonArray() {
        return responseResultList;
    }

    public void setJsonArray(JSONArray jsonArray) {
        this.responseResultList = jsonArray;
    }
}
