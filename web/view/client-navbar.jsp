<header>
    <a href="${pageContext.request.contextPath}/home" class="logo">
        <img src="${pageContext.request.contextPath}/image/logo.png" alt="" class="logo">
    </a>
    <nav>
        <ul id="navbar">
            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/product">Shop</a></li>
            <li><a href="${pageContext.request.contextPath}/order">Order</a></li>
                <%
                    model.User user = (model.User) session.getAttribute("user");
                    if (user != null) {
                %>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>

            <% } else { %>
            <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                <% }%>
            <li id="lg-bag"><a href="${pageContext.request.contextPath}/cart"><i class="fa fa-bag-shopping"></i></a></li>
            <a href="#" id="close"><i class="fa-solid fa-xmark"></i></a>
        </ul>
    </nav>
    <div id="mobile">
        <a href="${pageContext.request.contextPath}/cart"><i class="fa fa-bag-shopping"></i></a>
        <i id="bar" class="fas fa-outdent"></i>
    </div>
</header>
