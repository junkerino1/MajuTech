package utils;

import javax.net.ssl.*;
import java.security.cert.X509Certificate;
import java.security.NoSuchAlgorithmException;
import java.security.KeyManagementException;

public class SSLUtil {

    // Method to disable SSL verification
    public static void disableSslVerification() throws NoSuchAlgorithmException, KeyManagementException {
        // Set up a TrustManager that accepts all certificates (this is unsafe for production)
        TrustManager[] trustAllCertificates = new TrustManager[]{
            new X509TrustManager() {
                public X509Certificate[] getAcceptedIssuers() {
                    return null; // Return null to trust all certificates
                }

                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                    // Trust all clients
                }

                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                    // Trust all servers
                }
            }
        };

        // Install the all-trusting TrustManager into the SSLContext
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, trustAllCertificates, new java.security.SecureRandom());

        // Set the default SSLContext to use the one we created (bypassing certificate validation)
        SSLContext.setDefault(sslContext);
    }
}
