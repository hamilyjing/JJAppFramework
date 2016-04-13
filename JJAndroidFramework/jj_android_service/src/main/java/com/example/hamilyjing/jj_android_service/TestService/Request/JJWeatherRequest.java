package com.example.hamilyjing.jj_android_service.TestService.Request;

import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJRequest;

/**
 * Created by JJ on 4/13/16.
 */
public class JJWeatherRequest extends JJRequest {

    @Override
    public String baseUrl() {
        return "http://apis.baidu.com/showapi_open_bus/weather_showapi/areaid";
    }
}
