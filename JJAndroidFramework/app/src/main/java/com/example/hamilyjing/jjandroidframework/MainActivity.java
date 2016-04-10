package com.example.hamilyjing.jjandroidframework;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJBaseRequest;
import com.example.hamilyjing.jj_android_service.Tool.JJNetwork.JJNetworkAgent;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        JJBaseRequest request = new JJBaseRequest();
        JJNetworkAgent.getInstance().addRequest(request);
    }
}
