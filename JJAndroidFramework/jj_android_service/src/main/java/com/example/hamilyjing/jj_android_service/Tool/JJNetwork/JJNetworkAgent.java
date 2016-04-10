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
    private Integer index = 1;

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
        textHttpResponseHandler.request = request;

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
            }
            break;
        }

        addOperation(request);
    }

    public void cancelRequest(JJBaseRequest request)
    {
        removeOperation(request);
    }

    public void cancelAllRequest()
    {
        synchronized(this)
        {
            requestHashMap.clear();
        }
    }

    public String buildRequestUrl(JJBaseRequest request)
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

    private void addOperation(JJBaseRequest request)
    {
        synchronized(this)
        {
            requestHashMap.put(index, request);
            request.index = index;
            index = index + 1;
        }
    }

    private void removeOperation(JJBaseRequest request)
    {
        synchronized(this)
        {
            requestHashMap.remove(request.index);
        }
    }

    public void onSuccess(JJBaseRequest request, int i, Header[] headers, String s)
    {
        JJBaseRequest baseRequest = requestHashMap.get(request.index);
        if (null == baseRequest)
        {
            return;
        }

        removeOperation(baseRequest);
    }

    public void onFailure(JJBaseRequest request, int i, Header[] headers, String s, Throwable throwable)
    {
        JJBaseRequest baseRequest = requestHashMap.get(request.index);
        if (null == baseRequest)
        {
            return;
        }

        removeOperation(request);
    }
}
