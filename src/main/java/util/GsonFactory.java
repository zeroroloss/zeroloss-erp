package util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class GsonFactory {

    private static final Gson GSON;

    static {
        GsonBuilder gsonBuilder = new GsonBuilder();

        // LocalDateTime 변환기 등록
        gsonBuilder.registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter());

        // [Fix] LocalDate 변환기 추가
        gsonBuilder.registerTypeAdapter(LocalDate.class, new TypeAdapter<LocalDate>() {
            private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            @Override
            public void write(JsonWriter out, LocalDate value) throws IOException {
                if (value == null) {
                    out.nullValue();
                } else {
                    out.value(formatter.format(value));
                }
            }

            @Override
            public LocalDate read(JsonReader in) throws IOException {
                if (in.peek() == null) {
                    return null;
                }
                return LocalDate.parse(in.nextString(), formatter);
            }
        });

        GSON = gsonBuilder.create();
    }

    public static Gson getGson() {
        return GSON;
    }
}
