package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

/**
 * Created by hamilyjing on 4/11/16.
 */
public class JJRequest extends JJBaseRequest {

    public boolean isSaveToMemory() {
        return isSaveToMemory;
    }

    public void setIsSaveToMemory(boolean isSaveToMemory) {
        this.isSaveToMemory = isSaveToMemory;
    }

    public boolean isSaveToMemory;

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

    public boolean isSaveToDisk;

    private Object cacheModel;
    public Object oldModel;

    public Class modelClass;

    public Object getCacheModel() {
        return cacheModel;
    }

    public void setCacheModel(Object cacheModel) {
        this.cacheModel = cacheModel;
    }

    @Override
    public void requestCompleteFilter() {
        super.requestCompleteFilter();

        if (!isSaveToMemory && !isSaveToDisk) {
            return;
        }

        Object model = null;

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

    private boolean successForBussiness(Object model)
    {
        return false;
    }

    /// save cache

    public void saveObjectToMemory(Object model)
    {

    }

    public void saveObjectToDisk(Object model)
    {

    }

    public boolean haveDiskCache()
    {
        return false;
    }

    /// remove cache

    public void removeMemoryCache()
    {

    }

    public void removeDiskCache()
    {

    }

    public void removeAllCache()
    {

    }

    /// disk file

    public String savedFilePath()
    {
        return "";
    }

    public String savedFileDirectory()
    {
        return "";
    }

    public String savedFileName()
    {
        return "";
    }
}
