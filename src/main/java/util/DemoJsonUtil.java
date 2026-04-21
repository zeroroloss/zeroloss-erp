package util;

import com.google.gson.Gson;

public final class DemoJsonUtil {
    private static final Gson GSON = new Gson();

    private DemoJsonUtil() {
    }

    public static String toJson(Object object) {
        return GSON.toJson(object);
    }
}

