package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.RequestParams;

import org.apache.http.*;

import java.util.HashMap;

/**
 * Created by hamilyjing on 4/9/16.
 */
public class JJNetworkAgent {

    private static JJNetworkAgent instance = new JJNetworkAgent();

    private AsyncHttpClient client = new AsyncHttpClient();

    private HashMap<Integer, JJBaseRequest> requestHashMap = new HashMap<>();
    private Integer requestIndex = 1;

    public static JJNetworkAgent getInstance()
    {
        return instance;
    }

    private JJNetworkAgent()
    {
    }

    public void addRequest(JJBaseRequest request)
    {
        JJBaseRequest.JJRequestMethod method = request.requestMethod;
        String url = buildRequestUrl(request);
        RequestParams params = null;

        client.setTimeout(request.timeoutInterval);

        url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/areaid";

        JJTextHttpResponseHandler textHttpResponseHandler = new JJTextHttpResponseHandler();

        switch (method)
        {
            case JJRequestMethodPost:
            {
                client.post(url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodGet:
            {
                client.get(url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodDelete:
            {
                client.delete(url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodPut:
            {
                client.put(url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodPatch:
            {
                client.patch(url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodHead:
            {
                client.head(url, params, textHttpResponseHandler);
            }
            break;

            default:
            {
                return;
            }
        }

        Integer index = addOperation(request);
        textHttpResponseHandler.requestIndex = index;
        request.requestIndex = index;
    }

    public void cancelRequest(JJBaseRequest request)
    {
        removeOperation(request.requestIndex);
    }

    public void cancelAllRequest()
    {
        synchronized(this)
        {
            requestHashMap.clear();
        }
    }

    private String buildRequestUrl(JJBaseRequest request)
    {
        String detailUrl = request.requestUrl();
        if (detailUrl.startsWith("http"))
        {
            return detailUrl;
        }

        String baseUrl;
        if (request.useCDN())
        {
            baseUrl = request.cdnUrl();
        }
        else
        {
            baseUrl = request.baseUrl();
        }

        String url = baseUrl + detailUrl;
        return url;
    }

    private Integer addOperation(JJBaseRequest request)
    {
        Integer index;

        synchronized(this)
        {
            requestHashMap.put(requestIndex, request);
            index = requestIndex;
            requestIndex = requestIndex + 1;
        }

        return index;
    }

    private JJBaseRequest removeOperation(Integer index)
    {
        JJBaseRequest request;
        synchronized(this)
        {
            request = requestHashMap.remove(index);
        }

        return request;
    }

    public void onSuccess(Integer index, int i, Header[] headers, String s)
    {
        JJBaseRequest request = removeOperation(index);
        if (null == request)
        {
            return;
        }

        request.responseString = s;
        request.requestCompleteFilter();
        request.callBack.onSuccess(request);
    }

    public void onFailure(Integer index, int i, Header[] headers, String s, Throwable throwable)
    {
        JJBaseRequest request = removeOperation(index);
        if (null == request)
        {
            return;
        }

        request.responseString = s;
        request.requestFailedFilter();
        request.callBack.onFailure(request);
    }
}
