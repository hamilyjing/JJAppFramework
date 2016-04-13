package com.example.hamilyjing.jj_android_service.Tool.Model;

import com.alibaba.fastjson.JSONObject;

/**
 * Created by JJ on 4/13/16.
 */
public interface IResponseModel {

    boolean successForBussiness(Object model);

    void setData(JSONObject jsonObject);
}
