package com.example.hamilyjing.jj_android_service.TestService.FeatureSet;

import android.content.Context;

import com.example.hamilyjing.jj_android_service.ServiceFactory.IJJServiceCallBack;
import com.example.hamilyjing.jj_android_service.ServiceFactory.JJFeatureSet;
import com.example.hamilyjing.jj_android_service.TestService.Model.JJWeatherModel;
import com.example.hamilyjing.jj_android_service.TestService.Request.JJWeatherRequest;

/**
 * Created by JJ on 4/13/16.
 */
public class JJTestWeatherFeatureSet extends JJFeatureSet {

    public static String featureSetName()
    {
        return "com.example.hamilyjing.jj_android_service.TestService.FeatureSet.JJTestWeatherFeatureSet";
    }

    public void requestWeather(final Context context, final IJJServiceCallBack serviceCallBack)
    {
        JJWeatherRequest weatherRequest = new JJWeatherRequest();
        weatherRequest.setContext(context);
        weatherRequest.setModelClass(JJWeatherModel.class);
        weatherRequest.setIsSaveToDisk(true);
        startRequst(context, weatherRequest, serviceCallBack);
    }
}
