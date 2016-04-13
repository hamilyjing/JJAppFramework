package com.example.hamilyjing.jj_android_service.Tool.JJNetwork;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.RequestParams;

import org.apache.http.*;

import java.util.HashMap;
import java.util.Map;

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
        JJBaseRequest.JJRequestMethod method = request.getRequestMethod();
        String url = buildRequestUrl(request);
        Map<String, String> paramsMap = request.requestArgument();
        RequestParams params = null;
        if (paramsMap != null)
        {
            params = new RequestParams(paramsMap);
        }

        //client.setTimeout(request.timeoutInterval);

        JJTextHttpResponseHandler textHttpResponseHandler = new JJTextHttpResponseHandler();

        switch (method)
        {
            case JJRequestMethodPost:
            {
                client.post(request.getContext(), url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodGet:
            {
                client.get(request.getContext(), url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodDelete:
            {
                client.delete(url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodPut:
            {
                client.put(request.getContext(), url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodPatch:
            {
                client.patch(request.getContext(), url, params, textHttpResponseHandler);
            }
            break;

            case JJRequestMethodHead:
            {
                client.head(request.getContext(), url, params, textHttpResponseHandler);
            }
            break;

            default:
            {
                return;
            }
        }

        Integer index = addOperation(request);
        textHttpResponseHandler.requestIndex = index;
        request.setRequestIndex(index);
    }

    public void cancelRequest(JJBaseRequest request)
    {
        removeOperation(request.getRequestIndex());
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

        request.setIsNetworkResponseSuccess(true);
        request.setResponseCode(200);
        request.setResponseString(s);
        request.requestCompleteFilter();
        request.getRequestCallBack().onSuccess(request);
    }

    public void onFailure(Integer index, int i, Header[] headers, String s, Throwable throwable)
    {
        JJBaseRequest request = removeOperation(index);
        if (null == request)
        {
            return;
        }

        request.setIsNetworkResponseSuccess(false);
        request.setResponseCode(i);
        request.setResponseString(s);
        request.requestFailedFilter();
        request.getRequestCallBack().onFailure(request);
    }
}
