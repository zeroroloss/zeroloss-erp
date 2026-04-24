package util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDateTime;

public class GsonFactory {

    private static final Gson GSON;

    static {
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter());
        GSON = gsonBuilder.create();
    }

    public static Gson getGson() {
        return GSON;
    }
}
