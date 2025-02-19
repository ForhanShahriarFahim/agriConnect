<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>agriConnect - Home</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success custom-navbar">
    <div class="container">
        <a class="navbar-brand" href="/">agriConnect</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Search Form -->
            <form action="/" method="get" class="form-inline ml-auto">
                <input class="form-control mr-sm-2 search-input" type="search" placeholder="Search products" aria-label="Search">
                <button class="btn btn-outline-light my-2 my-sm-0 search-btn" type="submit">Search</button>
            </form>
            <!-- Conditional Navigation Links -->
            <ul class="navbar-nav ml-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <li class="nav-item">
                            <a class="nav-link" href="/profile">
                                <i class="fas fa-user-circle"></i> Hello, ${sessionScope.loggedInUser}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/logout">
                                <i class="fas fa-sign-out-alt"></i> Sign Out
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="/login">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/register">
                                <i class="fas fa-user-plus"></i> Sign Up
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container my-5">
    <h2 class="mb-4 text-center">Featured Products</h2>
    <div class="row">
        <c:if test="${not empty products and not empty products.content}">
            <c:forEach var="product" items="${products.content}">
                <div class="col-md-4">
                    <div class="card product-card shadow-sm">
                        <c:if test="${not empty product.imageUrl}">
                            <img src="${product.imageUrl}" class="card-img-top" alt="${product.title}">
                        </c:if>
                        <div class="card-body">
                            <h5 class="card-title">${product.title}</h5>
                            <p class="card-text">${product.description}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="price">$${product.price}</span>
                                <a href="/productDetail?id=${product.id}" class="btn btn-sm btn-outline-primary">View</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty products or empty products.content}">
            <div class="col-12">
                <div class="alert alert-info text-center" role="alert">
                    No products available.
                </div>
            </div>
        </c:if>
    </div>

    <!-- Pagination -->
    <c:if test="${products.totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <c:if test="${products.hasPrevious()}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${products.number - 1}">Previous</a>
                    </li>
                </c:if>
                <c:forEach var="i" begin="0" end="${products.totalPages - 1}">
                    <li class="page-item ${i == products.number ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}">${i + 1}</a>
                    </li>
                </c:forEach>
                <c:if test="${products.hasNext()}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${products.number + 1}">Next</a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <p>&copy; 2025 agriConnect. All rights reserved.</p>
    </div>
</footer>

<!-- Font Awesome for icons -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
