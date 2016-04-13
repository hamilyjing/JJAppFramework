package com.example.hamilyjing.jj_android_service.TestService.Model;

import com.example.hamilyjing.jj_android_service.Tool.Model.JJBaseResponseModel;

/**
 * Created by JJ on 4/13/16.
 */
public class JJWeatherModel extends JJBaseResponseModel {

    private Long errNum;
    private String errMsg;

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
