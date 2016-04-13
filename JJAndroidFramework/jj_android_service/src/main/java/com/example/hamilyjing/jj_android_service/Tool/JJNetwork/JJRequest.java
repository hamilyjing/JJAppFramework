package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import android.content.Context;
import android.os.Environment;

import com.alibaba.fastjson.JSON;
import com.example.hamilyjing.jj_android_service.Tool.JJMD5;

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
    private Context context;

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
        return false;
    }

    public Object convertToModel(String responseString)
    {
        Object model = JSON.parseObject(responseString, modelClass);
        return model;
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

//        if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
//                || !Environment.isExternalStorageRemovable())
//        {
//            directory = getContext().getExternalCacheDir().getPath();
//        }
//        else
//        {
//            directory = getContext().getCacheDir().getPath();
//        }

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

    public Context getContext() {
        return context;
    }

    public void setContext(Context context) {
        this.context = context;
    }
}
