package com.example.hamilyjing.jjandroidframework.main.presenter;

import android.content.Context;

import com.example.hamilyjing.jj_android_service.ServiceFactory.IJJServiceCallBack;
import com.example.hamilyjing.jj_android_service.ServiceFactory.JJServiceFactory;
import com.example.hamilyjing.jj_android_service.TestService.JJTestService;

/**
 * Created by JJ on 4/13/16.
 */
public class MainPresenter {

    private Context context;

    public void requestWeather(IJJServiceCallBack serviceCallBack){
        try{
            ((JJTestService) JJServiceFactory.getInstance().getService(JJTestService.serviceName())).requestWeather(this.context, serviceCallBack);
        }catch (NullPointerException e)
        {
            e.printStackTrace();
        }
    }

    public Context getContext() {
        return context;
    }

    public void setContext(Context context) {
        this.context = context;
    }
}
