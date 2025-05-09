<%@page import="model.User"%>
<%@page import="model.Product"%>
<%@page import="model.ShippingAddress"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="model.OrderItem"%>
<%@page import="service.ReviewService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MajuTech - Order History</title>
        <link rel="icon" type="image" href="${pageContext.request.contextPath}/image/logo.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order-history.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* Empty orders styling to match cart.jsp */
            .empty-orders-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 400px;
                margin: 40px 0;
                padding: 0 20px;
            }

            .empty-orders-content {
                text-align: center;
                background-color: #ffffff;
                border-radius: 8px;
                padding: 40px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                max-width: 600px;
                width: 100%;
            }

            .empty-icon-container {
                width: 100px;
                height: 100px;
                margin: 0 auto 25px;
                background-color: #f0f8f8;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
            }

            .empty-icon-container i {
                font-size: 40px;
                color: #0d9488; /* Teal color from the image */
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            .empty-orders-content h2 {
                margin-bottom: 15px;
                color: #333;
                font-size: 24px;
                font-weight: 600;
            }

            .empty-orders-content p {
                color: #666;
                margin-bottom: 30px;
                line-height: 1.6;
                font-size: 16px;
            }

            .shop-now-btn {
                display: inline-block;
                background-color: #0d9488; /* Teal color from the image */
                color: white;
                padding: 14px 28px;
                text-decoration: none;
                border-radius: 4px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .shop-now-btn:hover {
                background-color: #0a7d73;
            }

            .shop-now-btn i {
                margin-left: 8px;
            }

            @media (max-width: 768px) {
                .empty-orders-content {
                    padding: 30px 20px;
                }
            }
        </style>
    </head>
    <body>

        <jsp:include page="client-navbar.jsp"/>

        <div class="container">
            <div class="page-header">
                <h1>Order History</h1>
                <div class="filter-controls">
                    <div class="search-box">
                        <input type="text" id="orderSearchInput" placeholder="Search by order number..." oninput="filterOrders()">
                    </div>
                    <select class="filter-dropdown" onchange="filterByStatus()">
                        <option value="all">All Orders</option>
                        <option value="delivered">Delivered</option>
                        <option value="processing">Processing</option>
                        <option value="shipped">Shipped</option>
                    </select>
                </div>
            </div>

            <%
                Map<OrderItem, Boolean> reviewStatusMap = (Map<OrderItem, Boolean>) request.getAttribute("reviewStatusMap");
                Map<Order, List<OrderItem>> orderMap = (Map<Order, List<OrderItem>>) request.getAttribute("orderMap");
                User user = (User) request.getSession().getAttribute("user");
                String username = user.getUsername();
            %>

            <% if (orderMap == null || orderMap.isEmpty()) { %>
            <div class="empty-orders-container">
                <div class="empty-orders-content">
                    <div class="empty-icon-container">
                        <i class="fa-solid fa-box-open empty-icon"></i>
                    </div>
                    <h2>Your order history is empty</h2>
                    <p>It looks like you haven't added any orders yet. Browse our collection and discover amazing products that you'll love.</p>
                    <a href="${pageContext.request.contextPath}/product" class="shop-now-btn">
                        Start Shopping
                    </a>
                </div>
            </div>
            <% } else { %>
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
                            <% } else { %>
                            <span class="order-status status-shipped">Shipped</span>
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
                                    boolean hasReview = reviewStatusMap.get(item);
                            %>
                            <div class="product-item">
                                <div class="product-image">
                                    <img src="<%= p.getImage1()%>" alt="<%= p.getProductName()%>" />
                                </div>
                                <div class="product-details">
                                    <div class="product-name"><%= p.getProductName()%></div>
                                    <div class="product-meta">Quantity: <%= item.getQuantity()%></div>
                                    <div class="product-price">RM <%= String.format("%.2f", item.getCurrentPrice())%></div>
                                    <% if ("Delivered".equalsIgnoreCase(order.getStatus()) && !hasReview) {%>
                                    <div class="review-button-container">
                                        <button class="review-button" onclick="openReviewModal(<%= p.getId()%>, <%= order.getOrderId()%>, '<%= p.getProductName()%>', '<%= p.getImage1()%>', '<%= orderDate%>')">
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
                                    <div class="total-value">RM <%= String.format("%.2f", order.getTotalAmount())%></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% }%>
        </div>

        <!-- Modal Popup Container -->
        <div class="modal-overlay" id="modalOverlay">
            <div class="review-modal">
                <div class="close-modal">&times;</div>

                <h2 class="modal-title">Rate Product</h2>

                <div class="product-info">
                    <div class="product-image">
                        <img id="modalProductImage" src="" alt="Product Image">
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
        function filterOrders() {
            const input = document.getElementById('orderSearchInput').value.toLowerCase();
            const orderCards = document.querySelectorAll('.order-card');

            orderCards.forEach(card => {
                const orderIdElement = card.querySelector('.order-id');
                const orderIdText = orderIdElement ? orderIdElement.textContent.toLowerCase() : '';

                if (orderIdText.includes(input)) {
                    card.style.display = 'block'; // show
                } else {
                    card.style.display = 'none'; // hide
                }
            });
        }

        function filterByStatus() {
            const filterValue = document.querySelector('.filter-dropdown').value.toLowerCase();
            const orderCards = document.querySelectorAll('.order-card');

            orderCards.forEach(card => {
                const statusElement = card.querySelector('.order-status');
                const statusText = statusElement ? statusElement.textContent.toLowerCase() : '';

                if (filterValue === 'all' || statusText.includes(filterValue)) {
                    card.style.display = 'block'; // show
                } else {
                    card.style.display = 'none'; // hide
                }
            });
        }




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
            document.querySelectorAll('.star').forEach(function (s) {
                s.classList.remove('selected');
            });

            // Show modal with animation
            const modal = document.getElementById('modalOverlay');
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Prevent scrolling when modal is open
        }
        // Close modal functionality
        document.querySelector('.close-modal').addEventListener('click', function () {
            closeModal();
        });
        // Close modal when clicking outside
        document.getElementById('modalOverlay').addEventListener('click', function (e) {
            if (e.target === document.getElementById('modalOverlay')) {
                closeModal();
            }
        });

        // Function to close modal with animation
        function closeModal() {
            const modal = document.getElementById('modalOverlay');
            modal.style.opacity = '0';
            setTimeout(function () {
                modal.style.display = 'none';
                modal.style.opacity = '1';
                document.body.style.overflow = 'auto'; // Re-enable scrolling
            }, 300);
        }
        // Star rating functionality
        document.querySelectorAll('.stars-container').forEach(function (container) {
            const stars = container.querySelectorAll('.star');

            stars.forEach(function (star, index) {
                star.addEventListener('click', function () {
                    // Reset all stars
                    stars.forEach(function (s) {
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
                star.addEventListener('mouseover', function () {
                    // Show hover state for this star and all before it
                    for (let i = 0; i <= index; i++) {
                        if (!stars[i].classList.contains('selected')) {
                            stars[i].style.fill = '#ffd166';
                        }
                    }
                });

                star.addEventListener('mouseout', function () {
                    // Remove hover state
                    stars.forEach(function (s) {
                        if (!s.classList.contains('selected')) {
                            s.style.fill = '';
                        }
                    });
                });
            });
        });
        // Cancel button functionality
        document.querySelector('.cancel-button').addEventListener('click', function () {
            closeModal();
        });

        // Submit review functionality
        document.getElementById('submitReviewBtn').addEventListener('click', function () {
            submitReview(currentProductId, currentOrderId);
        });

        function submitReview(productId, orderId) {
            const reviewText = document.getElementById('reviewText').value;
            const isAnonymous = document.getElementById('anonymous').checked;

            if (ratingValue === 0) {
                alert('Please select a star rating');
                return;
            }

            // Create URL-encoded data string
            const data = new URLSearchParams();
            data.append('productId', productId);
            data.append('orderId', orderId);
            data.append('rating', ratingValue);
            data.append('reviewText', reviewText);
            data.append('username', '<%= user.getUsername()%>');
            data.append('anonymous', isAnonymous);

            // Send AJAX request to submit review
            fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: data.toString()
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Review submitted successfully!');
                            closeModal();
                            location.reload();
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