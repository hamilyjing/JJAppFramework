package com.example.hamilyjing.jjandroidframework;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.IJJRequestCallBack;
import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJBaseRequest;
import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJRequest;

class JJResult
{
    Long errNum;
    String errMsg;

    public Long getErrNum() {
        return errNum;
    }

    public void setErrNum(Long errNum) {
        this.errNum = errNum;
    }

    public String getErrMsg() {
        return errMsg;
    }

    public void setErrMsg(String errMsg) {
        this.errMsg = errMsg;
    }
}

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        JJRequest request = new JJRequest();
        request.setContext(this);
        request.setModelClass(JJResult.class);
        request.setIsSaveToDisk(true);
        request.startWithCallBack(new IJJRequestCallBack() {
            @Override
            public void onSuccess(JJBaseRequest request) {
                Integer i = request.requestIndex;
            }

            @Override
            public void onFailure(JJBaseRequest request) {
                Integer i = request.requestIndex;
            }
        });
    }
}
