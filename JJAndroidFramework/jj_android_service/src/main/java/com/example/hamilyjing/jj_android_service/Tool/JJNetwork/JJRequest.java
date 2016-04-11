package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

/**
 * Created by hamilyjing on 4/11/16.
 */
public class JJRequest extends JJBaseRequest {

    public boolean isSaveToMemory;
    public boolean isSaveToDisk;

    @Override
    public void requestCompleteFilter() {
        super.requestCompleteFilter();

        if (!isSaveToMemory && !isSaveToDisk) {
            return;
        }
    }
}
