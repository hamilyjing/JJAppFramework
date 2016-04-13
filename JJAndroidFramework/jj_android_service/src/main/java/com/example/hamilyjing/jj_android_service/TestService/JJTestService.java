package com.example.hamilyjing.jj_android_service.TestService;

import android.content.Context;

import com.example.hamilyjing.jj_android_service.ServiceFactory.IJJServiceCallBack;
import com.example.hamilyjing.jj_android_service.ServiceFactory.JJService;
import com.example.hamilyjing.jj_android_service.TestService.FeatureSet.JJTestWeatherFeatureSet;

/**
 * Created by JJ on 4/13/16.
 */
public class JJTestService extends JJService {

    public static String serviceName() {
        return "com.example.hamilyjing.jj_android_service.TestService.JJTestService";
    }

    public void requestWeather(Context context, final IJJServiceCallBack serviceCallBack) {
        try{
            JJTestWeatherFeatureSet weatherFeatureSet = (JJTestWeatherFeatureSet)getFeatureSet(JJTestWeatherFeatureSet.featureSetName());
            weatherFeatureSet.requestWeather(context, serviceCallBack);
        }catch (NullPointerException e)
        {
            e.printStackTrace();
        }
    }
}
