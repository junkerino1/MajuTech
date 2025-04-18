package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.*;
import java.net.*;
import java.util.Random;
import utils.SSLUtil;

/**
 *
 * @author junky
 */
public class RequestOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String phoneNumber = request.getParameter("phoneNumber");
        
        sendSms(phoneNumber);
        
        
    }
    
    public static int generateFourDigitNumber() {
        Random random = new Random();
        return 1000 + random.nextInt(9000); // ensures number is between 1000 and 9999
    }
    
    public void sendSms(String phoneNumber) {
        
        try {
            String user = "4open9Ed7A";
            String pass = "8gXuaj0RXJd4lz642g3E8iq1aAGzIY6zsnm7iBJ4";
            
            int otp = generateFourDigitNumber();
            String message = "Your OTP for MajuTech is " + otp;
            
            String encodedMessage = URLEncoder.encode(message, "UTF-8");

            String requestUrl = "https://sms.360.my/gw/bulk360/v3_0/send.php?" +
                "user=" + user +
                "&pass=" + pass +
                "&to=" + phoneNumber +
                "&text=" + encodedMessage;

            URL url = new URL(requestUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // Handle response
            System.out.println("SMS sent: " + response.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
}
