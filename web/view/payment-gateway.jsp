<%@page import="model.Product"%>
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
        <style>
            /* Form validation styles */
            .form-group {
                margin-bottom: 15px;
                position: relative;
            }
            
            .form-group.success input {
                border-color: #2ecc71;
                border-width: 2px;
            }
            
            .form-group.error input {
                border-color: #e74c3c;
                border-width: 2px;
            }
            
            .error-message {
                color: #e74c3c;
                font-size: 12px;
                display: block;
                margin-top: 3px;
                font-weight: 500;
            }
            
            /* Disable button styles */
            button:disabled {
                background-color: #cccccc !important;
                cursor: not-allowed;
                opacity: 0.7;
            }
            
            /* Shake animation for errors */
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
                20%, 40%, 60%, 80% { transform: translateX(5px); }
            }
            
            .shake {
                animation: shake 0.5s;
            }
        </style>
    </head>

    <jsp:include page="client-navbar.jsp"/>

    <body>

        <%
            int cartId = (int) request.getAttribute("cartId");
            int addressId = (int) request.getAttribute("addressId");
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
                        <form id="card-payment-form" action="${pageContext.request.contextPath}/payment" method="POST" novalidate>
                            <div class="form-group" style="position: relative;">
                                <label for="card-number">Card Number*</label>
                                <input type="text" id="card-number" placeholder="1234 5678 9012 3456" maxlength="19">
                                <div class="creditcard-icon">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M20 4H4C2.89 4 2.01 4.89 2.01 6L2 18C2 19.11 2.89 20 4 20H20C21.11 20 22 19.11 22 18V6C22 4.89 21.11 4 20 4ZM20 18H4V12H20V18ZM20 8H4V6H20V8Z" fill="currentColor"/>
                                    </svg>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="cardholder-name">Cardholder Name*</label>
                                <input type="text" id="cardholder-name" placeholder="Name as appears on card">
                            </div>

                            <div class="card-row">
                                <div class="form-group">
                                    <label for="expiry">Expiration Date*</label>
                                    <input type="text" id="expiry" placeholder="MM/YY" maxlength="5">
                                </div>

                                <div class="form-group">
                                    <label for="cvv">CVV*</label>
                                    <input type="text" id="cvv" placeholder="123" maxlength="4">
                                </div>
                            </div>
                            
                            <input type="hidden" name="paymentMethod" value="card">
                            <input type="hidden" name="addressId" value="<%= addressId%>">
                            <input type="hidden" name="cartId" value="<%= cartId%>">
                            <button type="submit" id="card-submit-btn" class="btn">Pay Now</button>
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
                        <form id="ewallet-payment-form" action="${pageContext.request.contextPath}/payment" method="POST" novalidate>
                            <div class="form-group">
                                <label for="phone-number">Phone Number*</label>
                                <input type="tel" id="phone-number" name="phone-number" placeholder="Enter your registered phone number">
                            </div>

                            <button type="button" id="request-otp-btn" class="btn">Request OTP</button>

                            <div class="otp-section" id="otp-section" style="display: none;">
                                <p>Enter the 4-digit OTP sent to your mobile phone</p>
                                <div class="otp-input">
                                    <input type="text" class="otp-digit" maxlength="1" pattern="[0-9]">
                                    <input type="text" class="otp-digit" maxlength="1" pattern="[0-9]">
                                    <input type="text" class="otp-digit" maxlength="1" pattern="[0-9]">
                                    <input type="text" class="otp-digit" maxlength="1" pattern="[0-9]">
                                </div>
                                <div class="otp-error" style="color: #e74c3c; font-size: 12px; margin-top: 5px; display: none;">
                                    Please enter all OTP digits
                                </div>
                                <a href="#" class="resend">Didn't receive OTP? Resend</a>
                                
                                <input type="hidden" name="paymentMethod" value="ewallet">
                                <input type="hidden" name="addressId" value="<%= addressId%>">
                                <input type="hidden" name="cartId" value="<%= cartId%>">
                                <button type="submit" id="ewallet-submit-btn" class="btn" style="margin-top: 20px;">Verify & Pay</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="order-summary">
                    <h2>Order Summary</h2>

                    <%
                        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
                        List<Product> productsInCart = (List<Product>) request.getAttribute("productsInCart");

                        double total = 0.0;
                        double shipping = 5.99;

                        if (cartItems != null && productsInCart != null && !cartItems.isEmpty() && cartItems.size() == productsInCart.size()) {
                    %>

                    <div class="order-items">
                        <%
                            for (int i = 0; i < cartItems.size(); i++) {
                                CartItem item = cartItems.get(i);
                                Product product = productsInCart.get(i);

                                double price = product.getEffectivePrice() * item.getQuantity();
                                total += price;
                        %>
                        <div class="order-item">
                            <div class="item-image">
                                <img src="<%= product.getImage1()%>" width="45px">
                            </div>
                            <div class="item-details">
                                <h4><%= product.getProductName()%></h4>
                                <p>Quantity: <%= item.getQuantity()%></p>
                                <p class="item-price">RM <%= String.format("%.2f", price)%></p>
                            </div>
                        </div>
                        <%
                            }

                            if (total > 1000) {
                                shipping = 0.0;
                            } else {
                                shipping = 10.0;
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
                    } else {
                    %>
                    <p class="empty-cart">Your cart is empty</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <script>
            // Tab switching function
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
                
                // Clear any previous validation messages
                clearValidationMessages();
            }
            
            // Clear validation messages
            function clearValidationMessages() {
                document.querySelectorAll('.form-group').forEach(group => {
                    group.classList.remove('error', 'success');
                });
                
                document.querySelectorAll('.error-message').forEach(msg => {
                    msg.remove();
                });
            }

            // Form validation styles
            function showError(input, message) {
                const formGroup = input.parentElement;
                formGroup.classList.remove('success');
                formGroup.classList.add('error');
                
                // Remove any existing error messages first
                const existingError = formGroup.querySelector('.error-message');
                if (existingError) {
                    formGroup.removeChild(existingError);
                }
                
                // Add new error message
                const small = document.createElement('small');
                small.className = 'error-message';
                small.innerText = message;
                formGroup.appendChild(small);
                
                // Add shake animation
                input.classList.add('shake');
                setTimeout(() => {
                    input.classList.remove('shake');
                }, 500);
            }

            function showSuccess(input) {
                const formGroup = input.parentElement;
                formGroup.classList.remove('error');
                formGroup.classList.add('success');
                
                // Remove any existing error messages
                const existingError = formGroup.querySelector('.error-message');
                if (existingError) {
                    formGroup.removeChild(existingError);
                }
            }

            // Format card number with spaces
            function formatCardNumber(e) {
                let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
                const matches = value.match(/\d{4,16}/g);
                const match = matches && matches[0] || '';
                const parts = [];
                
                for (let i = 0, len = match.length; i < len; i += 4) {
                    parts.push(match.substring(i, i + 4));
                }
                
                if (parts.length) {
                    e.target.value = parts.join(' ');
                } else {
                    e.target.value = value;
                }
            }

            // Format expiry date with slash
            function formatExpiryDate(e) {
                let value = e.target.value.replace(/\D/g, '');
                
                if (value.length > 2) {
                    e.target.value = value.substring(0, 2) + '/' + value.substring(2, 4);
                } else {
                    e.target.value = value;
                }
            }
            
            // Validate Card Payment Form
            function validateCardPayment() {
                let isValid = true;
                
                // Card Number Validation
                const cardNumber = document.getElementById('card-number');
                const cleanCardNumber = cardNumber.value.replace(/\s+/g, '');
                
                if (cleanCardNumber === '') {
                    showError(cardNumber, 'Card number is required');
                    isValid = false;
                } else if (!/^\d{16}$/.test(cleanCardNumber)) {
                    showError(cardNumber, 'Card number must be 16 digits');
                    isValid = false;
                } else {
                    showSuccess(cardNumber);
                }
                
                // Cardholder Name Validation
                const cardholderName = document.getElementById('cardholder-name');
                if (cardholderName.value.trim() === '') {
                    showError(cardholderName, 'Cardholder name is required');
                    isValid = false;
                } else {
                    showSuccess(cardholderName);
                }
                
                // Expiry Date Validation
                const expiry = document.getElementById('expiry');
                const expiryRegex = /^(0[1-9]|1[0-2])\/([0-9]{2})$/;
                
                if (expiry.value.trim() === '') {
                    showError(expiry, 'Expiry date is required');
                    isValid = false;
                } else if (!expiryRegex.test(expiry.value)) {
                    showError(expiry, 'Enter a valid date (MM/YY)');
                    isValid = false;
                } else {
                    // Check if card is expired
                    const [month, year] = expiry.value.split('/');
                    const expiryDate = new Date(2000 + parseInt(year), parseInt(month) - 1);
                    const today = new Date();
                    
                    if (expiryDate < today) {
                        showError(expiry, 'Card has expired');
                        isValid = false;
                    } else {
                        showSuccess(expiry);
                    }
                }
                
                // CVV Validation
                const cvv = document.getElementById('cvv');
                if (cvv.value.trim() === '') {
                    showError(cvv, 'CVV is required');
                    isValid = false;
                } else if (!/^\d{3,4}$/.test(cvv.value)) {
                    showError(cvv, 'CVV must be 3 or 4 digits');
                    isValid = false;
                } else {
                    showSuccess(cvv);
                }
                
                return isValid;
            }
            
            // Validate Phone Number for E-Wallet
            function validatePhoneNumber() {
                const phoneNumber = document.getElementById('phone-number');
                const value = phoneNumber.value.trim().replace(/[\s-]/g, '');
                
                if (value === '') {
                    showError(phoneNumber, 'Phone number is required');
                    return false;
                } else if (!/^\d{10,12}$/.test(value)) {
                    showError(phoneNumber, 'Enter a valid phone number');
                    return false;
                } else {
                    showSuccess(phoneNumber);
                    return true;
                }
            }
            
            // Validate OTP
            function validateOTP() {
                const otpInputs = document.querySelectorAll('.otp-digit');
                const otpError = document.querySelector('.otp-error');
                let isComplete = true;
                
                otpInputs.forEach(input => {
                    if (input.value.trim() === '') {
                        input.style.borderColor = '#e74c3c';
                        isComplete = false;
                    } else {
                        input.style.borderColor = '#2ecc71';
                    }
                });
                
                if (!isComplete) {
                    otpError.style.display = 'block';
                    return false;
                } else {
                    otpError.style.display = 'none';
                    return true;
                }
            }
            
            // Request OTP function
            function requestOTP() {
                if (validatePhoneNumber()) {
                    document.getElementById('otp-section').style.display = 'block';
                    
                    // Focus on the first OTP input
                    document.querySelector('.otp-digit').focus();
                    
                    // In a real app, you would send an API request to send OTP
                    alert('OTP has been sent to your phone');
                }
            }

            // Complete Payment (final submission)
            function completePayment(event) {
                // In a real application, this would connect to a payment processor
                alert('Processing payment...');
            }

            // Initialize all form behaviors
            document.addEventListener('DOMContentLoaded', function() {
                // Credit Card formatting
                const cardNumber = document.getElementById('card-number');
                cardNumber.addEventListener('input', formatCardNumber);
                
                // Expiry date formatting
                const expiry = document.getElementById('expiry');
                expiry.addEventListener('input', formatExpiryDate);
                
                // Card form submission
                const cardForm = document.getElementById('card-payment-form');
                cardForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    if (validateCardPayment()) {
                        completePayment();
                        this.submit();
                    }
                });
                
                // Request OTP button
                const requestOtpBtn = document.getElementById('request-otp-btn');
                requestOtpBtn.addEventListener('click', requestOTP);
                
                // E-wallet form submission
                const ewalletForm = document.getElementById('ewallet-payment-form');
                ewalletForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    const otpSection = document.getElementById('otp-section');
                    
                    if (validatePhoneNumber()) {
                        if (otpSection.style.display === 'block') {
                            if (validateOTP()) {
                                completePayment();
                                this.submit();
                            }
                        } else {
                            requestOTP();
                        }
                    }
                });
                
                // Auto-tab for OTP inputs
                const otpInputs = document.querySelectorAll('.otp-digit');
                otpInputs.forEach((input, index) => {
                    // When typing a digit
                    input.addEventListener('input', function() {
                        if (this.value.length === 1) {
                            // Move to next input if available
                            if (index < otpInputs.length - 1) {
                                otpInputs[index + 1].focus();
                            }
                            this.style.borderColor = '#2ecc71';
                        }
                    });
                    
                    // Handle backspace to go back
                    input.addEventListener('keydown', function(e) {
                        if (e.key === 'Backspace' && this.value === '' && index > 0) {
                            otpInputs[index - 1].focus();
                        }
                    });
                    
                    // Validate that only numbers are entered
                    input.addEventListener('input', function() {
                        this.value = this.value.replace(/[^0-9]/g, '');
                    });
                });
                
                // "Resend OTP" link
                document.querySelector('.resend').addEventListener('click', function(e) {
                    e.preventDefault();
                    alert('New OTP has been sent to your phone');
                    
                    // Clear existing OTP inputs
                    otpInputs.forEach(input => {
                        input.value = '';
                        input.style.borderColor = '';
                    });
                    
                    // Focus on first input
                    otpInputs[0].focus();
                });
            });
        </script>
    </body>

    <jsp:include page="client-footer.jsp"/>

</html>

