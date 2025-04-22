<%-- 
    Document   : order-history
    Created on : Apr 17, 2025, 12:19:49 PM
    Author     : junky
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
<<<<<<< Updated upstream
        <h1>Hello World!</h1>
    </body>
</html>
=======

        <jsp:include page="client-navbar.jsp"/>

        <div class="container">
            <div class="page-header">
                <h1>Order History</h1>
                <div class="filter-controls">
                    <div class="search-box">
                        <input type="text" placeholder="Search by order number, product name...">
                    </div>
                    <select class="filter-dropdown">
                        <option value="all">All Orders</option>
                        <option value="delivered">Delivered</option>
                        <option value="processing">Processing</option>
                        <option value="shipped">Shipped</option>
                    </select>
                </div>
            </div>

            <%
                Map<Order, List<OrderItem>> orderMap = (Map<Order, List<OrderItem>>) request.getAttribute("orderMap");
            %>


            <div class="order-list">
                <% for (Map.Entry<Order, List<OrderItem>> entry : orderMap.entrySet()) {
                        Order order = entry.getKey();
                        List<OrderItem> items = entry.getValue();
                        ShippingAddress address = order.getShippingAddress();
                %>

                <!-- Order Card -->
                <div class="order-card">
                    <div class="order-header">
                        <div>
                            <span class="order-id">Order #<%= order.getOrderId()%></span>

                            <% if ("Delivered".equalsIgnoreCase(order.getStatus())) { %>
                            <span class="order-status status-delivered">Delivered</span>
                            <% } else if ("Processing".equalsIgnoreCase(order.getStatus())) { %>
                            <span class="order-status status-processing">Processing</span>
                            <% } %>
                        </div>

                        <%
                            java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("MMMM dd, yyyy");
                            String orderDate = order.getDate().format(formatter);
                        %>
                        <span class="order-date"><%= orderDate%></span>
                    </div>

                    <div class="order-content">
                        <div class="product-list">
                            <% for (OrderItem item : items) {
                                    Product p = item.getProduct();
                            %>
                            <div class="product-item">
                                <div class="product-image">
                                    <img src="<%= p.getImage1()%>" alt="<%= p.getProductName()%>" />
                                </div>
                                <div class="product-details">
                                    <div class="product-name"><%= p.getProductName()%></div>
                                    <div class="product-meta">Quantity: <%= item.getQuantity()%></div>
                                    <div class="product-price">RM <%= String.format("%.2f", item.getCurrentPrice()) %></div>
                                    
                                    <% if ("Delivered".equalsIgnoreCase(order.getStatus())) { %>
                                    <div class="review-button-container">
                                        <button class="review-button" onclick="openReviewModal(<%= p.getId() %>, <%= order.getOrderId() %>, '<%= p.getProductName() %>', '<%= p.getImage1() %>', '<%= orderDate %>')">
                                            Rate Your Product
                                        </button>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% }%>
                        </div>

                        <div class="order-summary">
                            <div class="order-address">
                                <div class="address-title">Shipping Address</div>
                                <div class="address-content">
                                    <%= address.getName()%><br>
                                    <%= address.getStreet1()%><br>
                                    <%= address.getStreet2()%><br>
                                    <%= address.getState()%>, <%= address.getPostcode()%><br>
                                    Phone: <%= address.getPhoneNumber()%>
                                </div>
                            </div>
                            <div class="order-totals">
                                <div class="total-row">
                                    <div class="total-label">Total</div>
                                    <div class="total-value">RM <%= String.format("%.2f", order.getTotalAmount()) %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% }%>
            </div>
        </div>
        
        <!-- Modal Popup Container -->
        <div class="modal-overlay" id="modalOverlay">
            <div class="review-modal">
                <div class="close-modal">&times;</div>

                <h2 class="modal-title">Rate Product</h2>

                <div class="product-info">
                    <div class="product-image">
                        <img id="modalProductImage" src="" alt="Product Image" onerror="this.src='${pageContext.request.contextPath}/image/placeholder.png'">
                    </div>
                    <div class="product-details">
                        <div class="product-name" id="modalProductName"></div>
                        <div class="order-info" id="modalOrderInfo"></div>
                    </div>
                </div>

                <div class="rating-section">
                    <div class="rating-title">Product Quality</div>
                    <div class="stars-container">
                        <svg class="star" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                        </svg>
                        <svg class="star" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                        </svg>
                        <svg class="star" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                        </svg>
                        <svg class="star" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                        </svg>
                        <svg class="star" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
                        </svg>
                    </div>
                    <div class="review-form">
                        <textarea name="reviewText" id="reviewText" placeholder="Performance: write about this aspect.&#10;&#10;Share more thoughts on the product to help other buyers."></textarea>
                    </div>
                </div>

                <div class="anonymous-option">
                    <input type="checkbox" id="anonymous" name="anonymous">
                    <label for="anonymous">Leave your review anonymously</label>
                </div>
                <div class="username-note">Your user name will be shown as ${user.getUsername()}</div>

                <div class="action-buttons">
                    <button class="cancel-button">CANCEL</button>
                    <button class="submit-button" id="submitReviewBtn">SUBMIT</button>
                </div>
            </div>
        </div>
    </body>
<script>
    // Variables to store current product and order IDs
    let currentProductId = 0;
    let currentOrderId = 0;
    let ratingValue = 0;

    // Function to open modal with specific product/order info
    function openReviewModal(productId, orderId, productName, productImage, orderDate) {
        // Store current product and order IDs
        currentProductId = productId;
        currentOrderId = orderId;
        
        // Set modal content
        document.getElementById('modalProductName').textContent = productName;
        document.getElementById('modalProductImage').src = productImage;
        document.getElementById('modalOrderInfo').textContent = 'Order #' + orderId + ' • Delivered on ' + orderDate;
        
        // Reset rating and review text
        ratingValue = 0;
        document.getElementById('reviewText').value = '';
        document.getElementById('anonymous').checked = false;
        document.querySelectorAll('.star').forEach(function(s) {
            s.classList.remove('selected');
        });
        
        // Show modal with animation
        const modal = document.getElementById('modalOverlay');
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Prevent scrolling when modal is open
    }

    // Close modal functionality
    document.querySelector('.close-modal').addEventListener('click', function() {
        closeModal();
    });

    // Close modal when clicking outside
    document.getElementById('modalOverlay').addEventListener('click', function(e) {
        if (e.target === document.getElementById('modalOverlay')) {
            closeModal();
        }
    });
    
    // Function to close modal with animation
    function closeModal() {
        const modal = document.getElementById('modalOverlay');
        modal.style.opacity = '0';
        setTimeout(function() {
            modal.style.display = 'none';
            modal.style.opacity = '1';
            document.body.style.overflow = 'auto'; // Re-enable scrolling
        }, 300);
    }

    // Star rating functionality
    document.querySelectorAll('.stars-container').forEach(function(container) {
        const stars = container.querySelectorAll('.star');
        
        stars.forEach(function(star, index) {
            star.addEventListener('click', function() {
                // Reset all stars
                stars.forEach(function(s) {
                    s.classList.remove('selected');
                });
                
                // Select clicked star and all before it
                for (let i = 0; i <= index; i++) {
                    stars[i].classList.add('selected');
                }
                
                // Update rating value (1-5)
                ratingValue = index + 1;
            });
            
            // Hover effect for stars
            star.addEventListener('mouseover', function() {
                // Show hover state for this star and all before it
                for (let i = 0; i <= index; i++) {
                    if (!stars[i].classList.contains('selected')) {
                        stars[i].style.fill = '#ffd166';
                    }
                }
            });
            
            star.addEventListener('mouseout', function() {
                // Remove hover state
                stars.forEach(function(s) {
                    if (!s.classList.contains('selected')) {
                        s.style.fill = '';
                    }
                });
            });
        });
    });

    // Cancel button functionality
    document.querySelector('.cancel-button').addEventListener('click', function() {
        closeModal();
    });
    
    // Submit review functionality
    document.getElementById('submitReviewBtn').addEventListener('click', function() {
        submitReview(currentProductId, currentOrderId);
    });
    
    function submitReview(productId, orderId) {
        const reviewText = document.getElementById('reviewText').value;
        const isAnonymous = document.getElementById('anonymous').checked;
        
        if (ratingValue === 0) {
            alert('Please select a star rating');
            return;
        }
        
        // Create form data to send
        const formData = new FormData();
        formData.append('productId', productId);
        formData.append('orderId', orderId);
        formData.append('rating', ratingValue);
        formData.append('reviewText', reviewText);
        formData.append('anonymous', isAnonymous);
        
        // Send AJAX request to submit review
        fetch('${pageContext.request.contextPath}/submitReview', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Review submitted successfully!');
                closeModal();
                // Optionally refresh the page or update the UI
            } else {
                alert('Error submitting review: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred while submitting your review.');
        });
    }
</script>
    <jsp:include page="client-footer.jsp"/>
</html>
>>>>>>> Stashed changes
