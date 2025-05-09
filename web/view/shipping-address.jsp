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
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <title>MajuTech - Fill in Shipping Address</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment-gateway.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <title>Payment Gateway</title>
    </head>
    <body>
        <jsp:include page="client-navbar.jsp"/>

        <%
            List<ShippingAddress> address = (List<ShippingAddress>) request.getAttribute("address");
            int cartId = (int) request.getAttribute("cartId");
        %>

        <div class="container">
            <div class="checkout-container">
                <div class="payment-methods">
                    <h2>Checkout</h2>

                    <!-- Main Form for Existing Address Selection -->
                    <form id="existingAddressForm" action="${pageContext.request.contextPath}/process-address" method="POST">
                        <input type="hidden" name="cartId" value="<%= cartId%>" />

                        <!-- Existing Shipping Addresses -->
                        <div class="address-list">
                            <%
                                if (address != null && !address.isEmpty()) {
                                    int index = 0;
                                    for (ShippingAddress addr : address) {
                            %>
                            <div class="address-card <%= (index == 0) ? "selected" : ""%>">
                                <input type="radio" style="display: none;" name="existingAddressId" value="<%= addr.getId()%>" 
                                       id="address-<%= addr.getId()%>" <%= (index == 0) ? "checked" : ""%>>
                                <label for="address-<%= addr.getId()%>">
                                    <h4><%= addr.getName()%></h4>
                                    <p style="margin: 0"><%= addr.getStreet1()%></p>
                                    <p style="margin: 0"><%= addr.getStreet2()%></p>
                                    <p style="margin: 0"><%= addr.getPostcode()%> <%= addr.getState()%></p>
                                    <p style="margin: 0">Phone: <%= addr.getPhoneNumber()%></p>
                                </label>
                            </div>
                            <%
                                    index++;
                                }
                            } else {
                            %>
                            <p class="no-address">No saved addresses found. Please add a new address.</p>
                            <%
                                }
                            %>

                            <!-- Add New Address Button -->
                            <div class="address-card add-new" onclick="toggleNewAddress()">
                                <span>+ Add New Address</span>
                            </div>
                        </div>

                        <button class="btn" type="submit" id="continueWithExisting">Continue to Payment</button>
                    </form>

                    <!-- New Address Form (Hidden by Default) -->
                    <div class="step" id="new-address-form" style="display:none;">
                        <div class="address-section">
                            <h3>Shipping Address</h3>
                            <form id="newAddressForm" action="${pageContext.request.contextPath}/process-address" method="POST">
                                <!-- New Address Fields -->
                                <div class="form-group">
                                    <label for="full-name">Full Name</label>
                                    <input type="text" name="name" id="full-name" placeholder="Enter your full name" required>
                                </div>

                                <div class="form-group">
                                    <label for="address-line1">Address Line 1</label>
                                    <input type="text" name="street1" id="address-line1" placeholder="Street address, P.O. box" required>
                                </div>

                                <div class="form-group">
                                    <label for="address-line2">Address Line 2 (Optional)</label>
                                    <input type="text" name="street2" id="address-line2" placeholder="Apartment, suite, unit, building, floor, etc.">
                                </div>

                                <div class="card-row">
                                    <div class="form-group">
                                        <label for="state">State</label>
                                        <input type="text" name="state" id="state" placeholder="State/Province" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="zip">Postcode</label>
                                        <input type="text" name="postcode" id="zip" placeholder="ZIP/Postal code" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" name="phoneNumber" id="phone" placeholder="Phone number" required>
                                </div>

                                <input type="hidden" name="cartId" value="<%= cartId%>" />
                                <input type="hidden" name="newAddress" value="true" />

                                <div class="form-buttons">
                                    <div class="mb-10">
                                        <button type="button" class="btn secondary" onclick="toggleNewAddress()">Cancel</button>
                                    </div>
                                    <button class="btn" type="submit">Continue to Payment</button>
                                </div>
                            </form>
                        </div>
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
            function toggleNewAddress() {
                const newAddressForm = document.getElementById('new-address-form');
                const existingAddressForm = document.getElementById('existingAddressForm');
        
                if (newAddressForm.style.display === 'block') {
                    newAddressForm.style.display = 'none';
                    existingAddressForm.style.display = 'block';
                } else {
                    newAddressForm.style.display = 'block';
                    existingAddressForm.style.display = 'none';
                }
            }
        
            // When any address-card is clicked, mark it as selected and select its radio button
            document.querySelectorAll('.address-card:not(.add-new)').forEach(card => {
                card.addEventListener('click', function () {
                    // Remove 'selected' from all cards
                    document.querySelectorAll('.address-card').forEach(c => c.classList.remove('selected'));
        
                    // Add 'selected' to the clicked one
                    this.classList.add('selected');
        
                    // Select the radio button inside
                    const radio = this.querySelector('input[type="radio"]');
                    if (radio) {
                        radio.checked = true;
                    }
                });
            });
        
            // Validate existing address form before submission
            document.getElementById('existingAddressForm').addEventListener('submit', function (e) {
                const noAddressMsg = document.querySelector('.no-address');
                
                // If there's a "no address" message and no new address form is shown
                if (noAddressMsg && document.getElementById('new-address-form').style.display !== 'block') {
                    alert('Please add a shipping address before proceeding.');
                    e.preventDefault();
                    toggleNewAddress(); // Show the new address form
                    return;
                }
                
                // Check if any address is selected
                const hasCheckedRadio = document.querySelector('input[name="existingAddressId"]:checked');
                if (!hasCheckedRadio) {
                    alert('Please select a shipping address before proceeding.');
                    e.preventDefault();
                }
            });
        
            // Validate forms before submission
            document.getElementById('newAddressForm').addEventListener('submit', function (e) {
                // Validate required fields
                const requiredFields = ['full-name', 'address-line1', 'state', 'zip', 'phone'];
                for (const fieldId of requiredFields) {
                    const field = document.getElementById(fieldId);
                    if (!field.value.trim()) {
                        alert('Please complete all required fields.');
                        field.focus();
                        e.preventDefault();
                        return;
                    }
                }
        
                // Phone validation
                const phone = document.getElementById('phone').value;
                if (!/^\d{10,15}$/.test(phone)) {
                    alert('Please enter a valid phone number (10-15 digits)');
                    document.getElementById('phone').focus();
                    e.preventDefault();
                    return;
                }
        
                // Postal code validation
                const postcode = document.getElementById('zip').value;
                if (!/^\d{4,10}$/.test(postcode)) {
                    alert('Please enter a valid postal code');
                    document.getElementById('zip').focus();
                    e.preventDefault();
                    return;
                }
            });
            
            // If no addresses exist, automatically show the new address form on page load
            document.addEventListener('DOMContentLoaded', function() {
                const noAddressMsg = document.querySelector('.no-address');
                if (noAddressMsg) {
                    toggleNewAddress();
                }
            });
        </script>
    </body>
    <jsp:include page="client-footer.jsp"/>
</html>