package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.util.Map;

public class CloudinaryConfig {
    private static Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "dx91axmwl",
            "api_key", "914622214468953",
            "api_secret", "OkABhuWcgL7LcWzPY1R83q95MCI",
            "secure", true
        ));
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }
}
