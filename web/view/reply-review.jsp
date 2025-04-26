<%@page import="model.Product"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.Category" %>
<%@ page import="model.Review" %>
<%@ page import="model.Reply" %>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Panel</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
        <style>
            .first-level {
                max-height: 0;
                overflow: hidden;
                transition: max-height 0.3s ease;
                list-style: none;
                padding-left: 1rem;
            }

            .first-level.show {
                max-height: 500px;
            }

            .review-card {
                margin-bottom: 1.5rem;
                border-left: 4px solid #e9ecef;
            }

            .review-card.pending {
                border-left-color: #ffc107;
            }

            .review-card.replied {
                border-left-color: #198754;
            }

            .rating {
                color: #ffc107;
            }

            .empty-rating {
                color: #e0e0e0;
            }

            .reply-form {
                display: none;
            }

            .reply-form.active {
                display: block;
            }

            .staff-reply {
                background-color: #f8f9fa;
                border-radius: 0.25rem;
                padding: 1rem;
                margin-top: 1rem;
                border-left: 3px solid #0d6efd;
            }
        </style>


    <body>
        <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
             data-sidebar-position="fixed" data-header-position="fixed">

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />
            <!--  Main wrapper -->
            <div class="body-wrapper">

                <jsp:include page="admin-header.jsp"/>
                <!-- Main Content -->
                <div class="container-fluid">

                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title fw-semibold mb-4">Product Reviews & Comments</h5>



                                <!-- Reviews List -->
                                <div id="reviewsList">

                                    <%
                                        List<Review> reviews = (List<Review>) request.getAttribute("reviews");
                                        for (Review review : reviews) {
                                            Reply reply = review.getReply();
                                    %>

                                    <div class="card review-card <%= (reply == null ? "pending" : "replied") %>">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <h6 class="fw-semibold">
                                                    <%= review.getProduct().getProductName()%>
                                                </h6>
                                                <%
                                                    if (reply == null) {
                                                %>
                                                <span class="badge bg-warning">Pending Reply</span>
                                                <%
                                                } else {
                                                %>
                                                <span class="badge bg-success">Replied</span>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <p class="mb-1"><strong>Customer:</strong><%= review.getUsername()%></p>
                                                    <div class="rating mb-2">
                                                        <% for (int i = 0; i < 5; i++) {%>
                                                        <i class="bi <%= (i < review.getRating()) ? "bi-star-fill" : "bi-star"%>"></i>
                                                        <% }%>
                                                        <span class="ms-1">(<%= review.getRating()%>/5)</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <p><%= review.getComment()%></p>

                                            <% if (reply != null) {%>


                                            <div class="staff-reply">
                                                <div class="d-flex justify-content-between">
                                                    <p class="mb-1"><strong>Staff Reply:</strong> <span class="text-primary"><%= reply.getUsername()%></span></p>
                                                </div>
                                                <p><%= reply.getComment()%></p>
                                            </div>

                                            <% } else {%>

                                            <button type="button" class="btn btn-sm btn-outline-primary reply-btn mt-2">Reply</button>

                                            <div class="reply-form mt-3">
                                                <form action="${pageContext.request.contextPath}/admin/reply" method="post">
                                                    <div class="form-group">
                                                        <label for="reply-<%= review.getId()%>">Your Response</label>
                                                        <textarea class="form-control" rows="3" name="comment" placeholder="Type your reply here..."></textarea>
                                                        <input type="hidden" value="<%= review.getId()%>" name="reviewId"/>
                                                    </div>
                                                    <div class="mt-2">
                                                        <button type="submit" class="btn btn-primary btn-sm">Submit Reply</button>
                                                        <button type="button" class="btn btn-light btn-sm cancel-reply">Cancel</button>
                                                    </div>
                                                </form>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Chart.js for charts -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
        <script src="${pageContext.request.contextPath}/script/script.js"></script>
        <script>
            // Toggle reply form visibility
            document.querySelectorAll('.reply-btn').forEach(button => {
                button.addEventListener('click', function () {
                    const reviewCard = this.closest('.card');
                    const replyForm = reviewCard.querySelector('.reply-form');
                    replyForm.classList.toggle('active');
                    this.style.display = 'none';
                });
            });

            // Cancel reply
            document.querySelectorAll('.cancel-reply').forEach(button => {
                button.addEventListener('click', function () {
                    const reviewCard = this.closest('.card');
                    const replyForm = reviewCard.querySelector('.reply-form');
                    const replyBtn = reviewCard.querySelector('.reply-btn');
                    replyForm.classList.remove('active');
                    replyBtn.style.display = 'inline-block';
                });
            });
        </script>
    </body>

</html>