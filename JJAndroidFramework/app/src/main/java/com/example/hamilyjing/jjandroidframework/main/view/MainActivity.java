package com.example.hamilyjing.jjandroidframework.main.view;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.hamilyjing.jj_android_service.ServiceFactory.IJJServiceCallBack;
import com.example.hamilyjing.jj_android_service.TestService.Model.JJWeatherModel;
import com.example.hamilyjing.jjandroidframework.R;
import com.example.hamilyjing.jjandroidframework.main.presenter.MainPresenter;

public class MainActivity extends AppCompatActivity {

    private MainPresenter mainPresenter = new MainPresenter();

    private Button button;
    private TextView textView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mainPresenter.setContext(this);

        textView = (TextView)findViewById(R.id.textView);

        button = (Button)findViewById(R.id.button);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mainPresenter.requestWeather(new IJJServiceCallBack() {
                    @Override
                    public void onNetworkRequestSuccess(Object model, String responseString, Object otherInfo) {
                        JJWeatherModel weatherModel = (JJWeatherModel)model;
                        textView.setText(weatherModel.getErrMsg());
                    }

                    @Override
                    public void onNetworkRequestFailure(int code, String responseString, Object otherInfo) {
                        textView.setText("网络异常");
                    }
                });
            }
        });
    }
}
