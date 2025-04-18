<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.ShippingAddress" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment-gateway.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <title>Payment Gateway</title>
    </head>

    <jsp:include page="client-navbar.jsp"/>

    <body>

        <%
            int cartId = (int) request.getAttribute("cartId");
            int addressId = (int) request.getAttribute("addressId");

            double total = 0.0;
            double shipping = 5.99;

        %>

        <div class="container">
            <div class="checkout-container">
                <div class="payment-methods">
                    <h2>Step 2: Payment</h2>
                    <!-- Payment Method Section -->
                    <h3>Choose Payment Method</h3>
                    <div class="tabs">
                        <div class="tab active" onclick="switchTab('card')">Credit Card</div>
                        <div class="tab" onclick="switchTab('ewallet')">E-Wallet</div>
                    </div>

                    <!-- Credit Card Tab -->
                    <div class="tab-content active" id="tab-card">
                        <div class="form-group" style="position: relative;">
                            <label for="card-number">Card Number</label>
                            <input type="text" id="card-number" placeholder="1234 5678 9012 3456">
                            <div class="creditcard-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M20 4H4C2.89 4 2.01 4.89 2.01 6L2 18C2 19.11 2.89 20 4 20H20C21.11 20 22 19.11 22 18V6C22 4.89 21.11 4 20 4ZM20 18H4V12H20V18ZM20 8H4V6H20V8Z" fill="currentColor"/>
                                </svg>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="cardholder-name">Cardholder Name</label>
                            <input type="text" id="cardholder-name" placeholder="Name as appears on card">
                        </div>

                        <div class="card-row">
                            <div class="form-group">
                                <label for="expiry">Expiration Date</label>
                                <input type="text" id="expiry" placeholder="MM/YY">
                            </div>

                            <div class="form-group">
                                <label for="cvv">CVV</label>
                                <input type="text" id="cvv" placeholder="123">
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/payment" method="POST">
                            <input type="hidden" name="paymentMethod" value="card">
                            <input type="hidden" name="addressId" value="<%= addressId%>">
                            <input type="hidden" name="cartId" value="<%= cartId%>">
                            <button type="submit" class="btn" onclick="completePayment()">Pay Now</button>
                        </form>

                        <div class="secure-badge">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 1L3 5V11C3 16.55 6.84 21.74 12 23C17.16 21.74 21 16.55 21 11V5L12 1ZM12 11.99H19C18.47 16.11 15.72 19.78 12 20.93V12H5V6.3L12 3.19V11.99Z" fill="currentColor"/>
                            </svg>
                            Secure Payment
                        </div>
                    </div>

                    <!-- E-Wallet Tab -->
                    <div class="tab-content" id="tab-ewallet">
                        <div class="form-group">
                            <label for="phone-number">Phone Number</label>
                            <input type="tel" id="phone-number" name="phone-number" placeholder="Enter your registered phone number">
                        </div>

                        <button class="btn" onclick="requestOTP()">Request OTP</button>

                        <div class="otp-section" id="otp-section" style="display: none;">
                            <p>Enter the 4-digit OTP sent to your mobile phone</p>
                            <div class="otp-input">
                                <input type="text" maxlength="1">
                                <input type="text" maxlength="1">
                                <input type="text" maxlength="1">
                                <input type="text" maxlength="1">
                            </div>
                            <a href="#" class="resend">Didn't receive OTP? Resend</a>
                            <form action="${pageContext.request.contextPath}/payment" method="POST">
                                <input type="hidden" name="paymentMethod" value="ewallet">
                                <input type="hidden" name="addressId" value="<%= addressId%>">
                                <input type="hidden" name="cartId" value="<%= cartId%>">
                                <button class="btn" style="margin-top: 20px;" onclick="completePayment()">Verify & Pay</button>
                            </form>
                        </div>
                    </div>
                </div>


                <div class="order-summary">
                    <h2>Order Summary</h2>

                    <%
                        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");

                        if (cartItems != null && !cartItems.isEmpty()) {
                    %>

                    <div class="order-items">
                        <%
                            for (CartItem item : cartItems) {
                                double price = item.getProduct().getUnitPrice() * item.getQuantity();
                                total += price;
                        %>
                        <div class="order-item">
                            <div class="item-image">
                                <img src="<%= item.getProduct().getImage1()%>" width="45px">
                            </div>
                            <div class="item-details">
                                <h4><%= item.getProduct().getProductName()%></h4>
                                <p>Quantity: <%= item.getQuantity()%></p>
                                <p class="item-price">RM <%= String.format("%.2f", price)%></p>
                            </div>
                        </div>
                        <%
                            }

                            if (total > 1000) {
                                shipping = 0.0;
                            }

                            double grandTotal = total + shipping;
                        %>
                    </div>

                    <div class="order-total">
                        <div class="order-row">
                            <span>Subtotal</span>
                            <span>RM <%= String.format("%.2f", total)%></span>
                        </div>

                        <div class="order-row">
                            <span>Shipping</span>
                            <span>RM <%= String.format("%.2f", shipping)%></span>
                        </div>

                        <div class="order-row total-row">
                            <span>Total</span>
                            <span>RM <%= String.format("%.2f", grandTotal)%></span>
                        </div>
                    </div>

                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tab) {

            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));

            // Show selected tab
            if (tab === 'card') {
                document.querySelector('.tab:nth-child(1)').classList.add('active');
                document.querySelector('#tab-card').classList.add('active');
            } else if (tab === 'ewallet') {
                document.querySelector('.tab:nth-child(2)').classList.add('active');
                document.querySelector('#tab-ewallet').classList.add('active');
            }
        }

        function requestOTP() {

            document.getElementById('otp-section').style.display = 'block';
        }

        function completePayment() {
            alert('Processing payment...');
            // In a real application, this would connect to a payment processor
        }

        // Auto-tab for OTP inputs
        document.querySelectorAll('.otp-input input').forEach(input => {
            input.addEventListener('input', function () {
                if (this.value.length === 1) {
                    const nextInput = this.nextElementSibling;
                    if (nextInput) {
                        nextInput.focus();
                    }
                }
            });
        });

    </script>
</body>

<jsp:include page="client-footer.jsp"/>

</html>



