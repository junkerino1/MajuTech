<%@page import="model.Product"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Campaign" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Campaign</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
        </style>
    </head>
    <body>
        <div class="page-wrapper" id="main-wrapper" data-layout="vertical" data-navbarbg="skin6" data-sidebartype="full"
             data-sidebar-position="fixed" data-header-position="fixed">

            <!-- Include Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!--  Main wrapper -->
            <div class="body-wrapper">
                <jsp:include page="admin-header.jsp" />

                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                %>

                <div class="container-fluid">
                    <h5 class="card-title fw-semibold mb-4">Promotion & Campaign</h5>
                    <div class="card">
                        <div class="card-body">
                            <form id="promotionForm" method="post" action="${pageContext.request.contextPath}/admin/create-campaign">
                                <div class="form-group-inline mb-3">
                                    <label for="promotionName" class="form-label">Promotion Name</label>
                                    <input type="text" class="form-control" id="promotionName" name="promoName" required>
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="promotionDateStart" class="form-label">Date Start</label>
                                    <input type="date" class="form-control date-input" id="promotionDateStart" name="startDate">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="promotionDateEnd" class="form-label">Date End</label>
                                    <input type="date" class="form-control date-input" id="promotionDateEnd" name="endDate">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label for="productQuantity" class="form-label">Discount (%)</label>
                                    <input type="number" class="form-control quantity-input" id="promotionDiscount"
                                           max="100" min="0" name="percentageDiscount">
                                </div>
                                <div class="form-group-inline mb-3">
                                    <label class="form-label">Promotion Products</label>
                                    <div class="d-flex">
                                        <input type="text" class="form-control" id="promotionProduct" placeholder="Select up to 6 products" readonly>
                                        <input type="hidden" id="selectedProducts" name="promoItem">
                                        <button type="button" class="btn btn-secondary ms-2" data-bs-toggle="modal" data-bs-target="#productModal">Select</button>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalLabel">Select Promotion Products</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="text" id="productSearch" class="form-control mb-3" placeholder="Search products...">
                    <div id="productList" class="form-check">
                        <%
                            for (Product product : products) {
                        %>
                        <div class="form-check mb-2">
                            <input class="form-check-input product-checkbox" type="checkbox" value="<%= product.getId()%>" id="product-<%= product.getId()%>">
                            <label class="form-check-label" for="product-<%= product.getId()%>"><%= product.getProductName()%></label>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <div class="modal-footer">
                    <span class="text-danger me-auto" id="productError" style="display:none;">Select between 1 and 6
                        products.</span>
                    <button type="button" class="btn btn-primary" id="selectProductsBtn">Confirm</button>
                </div>
            </div>
        </div>
    </div>


    <script src="${pageContext.request.contextPath}/script/sidebarmenu.js"></script>
    <script src="${pageContext.request.contextPath}/script/script.js"></script>
    <script>
        // Get references to elements
        const promotionProductInput = document.getElementById("promotionProduct");
        const selectedProductsInput = document.getElementById("selectedProducts");
        const productError = document.getElementById("productError");

        renderProductList();

        productSearch.addEventListener("input", (e) => {
            renderProductList(e.target.value);
        });

        function renderProductList(filter = "") {
            const allCheckboxes = document.querySelectorAll("#productList .form-check");

            allCheckboxes.forEach(wrapper => {
                const label = wrapper.querySelector("label");
                const name = label.textContent.toLowerCase();
                if (name.includes(filter.toLowerCase())) {
                    wrapper.style.display = "block";
                } else {
                    wrapper.style.display = "none";
                }
            });
        }

        document.getElementById("selectProductsBtn").addEventListener("click", () => {
            const checkedBoxes = document.querySelectorAll(".product-checkbox:checked");

            if (checkedBoxes.length < 1 || checkedBoxes.length > 6) {
                productError.style.display = "block";
                return;
            }

            productError.style.display = "none";

            const selectedNames = Array.from(checkedBoxes).map(cb =>
                cb.nextElementSibling.textContent
            );
            const selectedIds = Array.from(checkedBoxes).map(cb => cb.value);

            // Show selected product names in input
            promotionProductInput.value = selectedNames.join(", ");

            // CHANGED: Store selected IDs as JSON in hidden input
            selectedProductsInput.value = JSON.stringify(selectedIds);

            const modal = bootstrap.Modal.getInstance(document.getElementById("productModal"));
            modal.hide();
        });

        function validateForm() {
        const startDateInput = document.getElementById("promotionDateStart");
        const endDateInput = document.getElementById("promotionDateEnd");
        const selectedProductsInput = document.getElementById("selectedProducts");

        const startDate = new Date(startDateInput.value);
        const endDate = new Date(endDateInput.value);

        // Date validation
        if (!startDateInput.value || !endDateInput.value) {
            alert("Please select both start and end dates.");
            return false;
        }

        if (startDate >= endDate) {
            alert("Start date must be before end date.");
            return false;
        }

        // Product count validation
        const selectedProductIds = selectedProductsInput.value.split(",");
        const filteredProductIds = selectedProductIds.filter(id => id.trim() !== "");

        if (filteredProductIds.length > 5) {
            alert("You can only select up to 5 products for the promotion.");
            return false;
        }
        
        
        return true;
    }
    </script>
</body>
</html>