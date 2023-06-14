package com.okode.firebase;

import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class AnalyticsMapper {
    private AnalyticsMapper() {}

    public static Bundle convertEventParamsToBundle(JSONObject params) throws JSONException {
        Bundle bundle = new Bundle();
        if (params == null) { return bundle; }

        Iterator<String> keys = params.keys();
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = params.get(key);

            if (value instanceof String) {
                bundle.putString(key, (String) value);
            } else if (value instanceof Integer) {
                bundle.putInt(key, (Integer) value);
            } else if (value instanceof Double) {
                bundle.putDouble(key, (Double) value);
            } else if (value instanceof Long) {
                bundle.putLong(key, (Long) value);
            } else if (value != null) {
                bundle.putString(key, value.toString());
            } else {
                throw new JSONException("Value for key " + key + " cannot be NULL");
            }
        }
        return bundle;
    }
}
