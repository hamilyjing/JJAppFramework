package com.example.hamilyjing.jj_android_service.Tool.Model;

import java.io.Serializable;

/**
 * Created by hamilyjing on 4/11/16.
 */
public class JJBaseResponseModel implements Serializable, IResponseModel
{
    private static final long serialVersionUID = 1;

    @Override
    public boolean successForBussiness(Object model) {
        return true;
    }
}
