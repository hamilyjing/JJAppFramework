package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONArray;
import com.example.hamilyjing.jj_android_service.Tool.JJMD5;
import com.example.hamilyjing.jj_android_service.Tool.Model.IResponseModel;
import com.example.hamilyjing.jj_android_service.Tool.Model.JJBaseResponseModel;
import com.example.hamilyjing.jj_android_service.Tool.ReflectUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 * Created by hamilyjing on 4/11/16.
 */
public class JJRequest extends JJBaseRequest
{
    private boolean isSaveToMemory;
    private boolean isSaveToDisk;

    private Object cacheModel;
    private Object oldModel;

    private Class modelClass;

    private IResponseOperation responseOperation;

    private String userCacheDirectory;
    private String sensitiveDataForSavedFileName;

    @Override
    public void requestCompleteFilter()
    {
        super.requestCompleteFilter();

        if (!isSaveToMemory && !isSaveToDisk)
        {
            return;
        }

        setOldModel(getCacheModel());

        Object model = currentResponseModel();

        if (!successForBussiness(model))
        {
            return;
        }

        if (isSaveToMemory)
        {
            setCacheModel(model);
        }

        if (isSaveToDisk)
        {
            saveObjectToDisk(model);
        }
    }

    /// operation

    public Object currentResponseModel()
    {
        Object model = convertToModel(this.getResponseString());
        model = operateWithNewObject(model, getOldModel());
        return model;
    }

    public boolean successForBussiness(Object model)
    {
        boolean successForBussiness = false;

        if (ReflectUtil.isInterface(model.getClass(), "com.example.hamilyjing.jj_android_service.Tool.Model.IResponseModel"))
        {
            successForBussiness = ((IResponseModel)model).successForBussiness(model);
        }

        return successForBussiness;
    }

    public Object convertToModel(String responseString)
    {
        Object object = JSON.parse(responseString);
        if (!(object instanceof com.alibaba.fastjson.JSONObject)) {
            return null;
        }

        Object convertObject = getConvertString((JSONObject) object);
        Object model;

        if (convertObject instanceof com.alibaba.fastjson.JSONObject)
        {
            String convertString = ((JSONObject) convertObject).toJSONString();
            model = JSON.parseObject(convertString, getModelClass());
        }
        else if (convertObject instanceof com.alibaba.fastjson.JSONArray)
        {
            model = ReflectUtil.objectFromClass(getModelClass());
            ((JJBaseResponseModel)model).setJsonArray((JSONArray)convertObject);
        }
        else if (convertObject instanceof String)
        {
            model = ReflectUtil.objectFromClass(getModelClass());
            ((JJBaseResponseModel)model).setResponseResultString((String)convertObject);
        }
        else
        {
            model = ReflectUtil.objectFromClass(getModelClass());
        }

        ((JJBaseResponseModel)model).setData((JSONObject)object);

        return model;
    }

    public Object getConvertString(JSONObject jsonObject){
        return jsonObject;
    }

    public Object operateWithNewObject(Object newModel, Object oldModel)
    {
        if (responseOperation != null)
        {
            return responseOperation.operate(newModel, oldModel);
        }

        return newModel;
    }

    /// cache

    public Object getCacheFromDisk()
    {
        Object model = null;
        ObjectInputStream inputStream;

        try
        {
            inputStream = new ObjectInputStream(new FileInputStream(new File(savedFilePath())));
            model = inputStream.readObject();
            inputStream.close();
        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        catch (ClassNotFoundException e)
        {
            e.printStackTrace();
        }

        return model;
    }

    public void saveObjectToMemory(Object model)
    {
        setCacheModel(model);
    }

    public void saveObjectToDisk(Object model)
    {
        ObjectOutputStream outputStream;
        try
        {
            outputStream = new ObjectOutputStream(new FileOutputStream(new File(savedFilePath())));
            outputStream.writeObject(model);
            outputStream.close();
        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public boolean haveDiskCache()
    {
        Object model = getCacheFromDisk();
        return (model != null);
    }

    public void removeMemoryCache()
    {
        setCacheModel(null);
    }

    public void removeDiskCache()
    {
        File file = new File(savedFilePath());
        if (file.isFile() && file.exists())
        {
            file.delete();
        }
    }

    public void removeAllCache()
    {
        removeMemoryCache();
        removeDiskCache();
    }

    /// disk file

    public String savedFilePath()
    {
        String filePath = savedFileDirectory() + "/" + savedFileName();
        return filePath;
    }

    public String savedFileDirectory()
    {
        String directory = getContext().getFilesDir().getPath();

        directory = directory + "/JJRequestCache";

        if (getUserCacheDirectory() != null && getUserCacheDirectory().length() > 0)
        {
            directory = directory + "/" + getUserCacheDirectory();
        }

        File destDir = new File(directory);
        if (!destDir.exists())
        {
            destDir.mkdirs();
        }

        return directory;
    }

    public String savedFileName()
    {
        String baseUrl = baseUrl();
        baseUrl = (baseUrl != null) ? baseUrl : "";

        String requestUrl = requestUrl();
        requestUrl = (requestUrl != null) ? baseUrl : "";

        String argumentSting = "";
        Map<String, String> argument = requestArgument();
        if (argument != null)
        {
            Set<String> keyList = argument.keySet();
            for (Iterator it = keyList.iterator(); it.hasNext();) {
                String key = (String)it.next();
                argumentSting += key + ":" + argument.get(key) + ",";
            }
        }

        String sensitiveData = (this.sensitiveDataForSavedFileName != null) ? this.sensitiveDataForSavedFileName : "";

        String fileName = baseUrl + requestUrl + argumentSting + sensitiveData;
        fileName = JJMD5.md5(fileName);

        return fileName;
    }

    /// get and set

    public boolean isSaveToMemory() {
        return isSaveToMemory;
    }

    public void setIsSaveToMemory(boolean isSaveToMemory) {
        this.isSaveToMemory = isSaveToMemory;
    }

    public boolean isSaveToDisk() {
        return isSaveToDisk;
    }

    public void setIsSaveToDisk(boolean isSaveToDisk) {
        this.isSaveToDisk = isSaveToDisk;
    }

    public Object getOldModel() {
        return oldModel;
    }

    public void setOldModel(Object oldModel) {
        this.oldModel = oldModel;
    }

    public Class getModelClass() {
        return modelClass;
    }

    public void setModelClass(Class modelClass) {
        this.modelClass = modelClass;
    }

    public Object getCacheModel()
    {
        if (this.cacheModel != null)
        {
            Object model = this.cacheModel;
            if (!isSaveToMemory())
            {
                setCacheModel(null);
            }
            return model;
        }

        Object model = getCacheFromDisk();
        if (isSaveToMemory())
        {
            setCacheModel(model);
        }

        return cacheModel;
    }

    public void setCacheModel(Object cacheModel) {
        this.cacheModel = cacheModel;
    }

    public IResponseOperation getResponseOperation() {
        return responseOperation;
    }

    public void setResponseOperation(IResponseOperation responseOperation) {
        this.responseOperation = responseOperation;
    }

    public String getUserCacheDirectory() {
        return userCacheDirectory;
    }

    public void setUserCacheDirectory(String userCacheDirectory) {
        this.userCacheDirectory = userCacheDirectory;
    }

    public String getSensitiveDataForSavedFileName() {
        return sensitiveDataForSavedFileName;
    }

    public void setSensitiveDataForSavedFileName(String sensitiveDataForSavedFileName) {
        this.sensitiveDataForSavedFileName = sensitiveDataForSavedFileName;
    }
}
