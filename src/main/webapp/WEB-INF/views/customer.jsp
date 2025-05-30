<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <h1 class="text-center mb-4">Welcome to Our Bakery</h1>

    <!-- Search and Filter Section -->
    <div class="row mb-4">
        <div class="col-md-6">
            <form action="${pageContext.request.contextPath}/products/customer" method="get" class="d-flex">
                <input type="text" name="search" class="form-control me-2" placeholder="Search products..." 
                       value="${searchQuery}">
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>
        <div class="col-md-6">
            <form action="${pageContext.request.contextPath}/products/customer" method="get" class="d-flex">
                <select name="category" class="form-select me-2" onchange="this.form.submit()">
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${cat == selectedCategory ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
                <input type="hidden" name="search" value="${searchQuery}">
            </form>
        </div>
    </div>

    <!-- Product Grid -->
    <div class="row">
        <c:if test="${empty products}">
            <div class="col-12 text-center">
                <p class="text-muted">No products found. Try adjusting your search or category.</p>
            </div>
        </c:if>
        <c:forEach var="product" items="${products}">
            <div class="col-md-4 mb-4">
                <a href="${pageContext.request.contextPath}/products/view/${product.id}" class="text-decoration-none">
                    <div class="card h-100 shadow-sm product-card">
                        <c:choose>
                            <c:when test="${not empty product.image}">
                                <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                     class="card-img-top" alt="${product.name}" style="height: 200px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="bg-light d-flex align-items-center justify-content-center" style="height: 200px;">
                                    <i class="bi bi-basket" style="font-size: 3rem;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body">
                            <h5 class="card-title text-dark">${product.name}</h5>
                            <p class="card-text text-muted">${product.category}</p>
                            <p class="card-text text-dark">
                                <fmt:formatNumber value="${product.price}" type="currency" currencyCode="LKR"/>
                            </p>
                            <c:set var="inStock" value="${product.currentStock > 0}" />
                            <span class="badge ${inStock ? 'bg-success' : 'bg-danger'} mb-2">
                                ${inStock ? 'In Stock' : 'Out of Stock'}
                            </span>
                            <p class="card-text text-dark">Current Stock: ${product.currentStock}</p>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</div>

<style>
    .product-card {
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    }
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
    }
</style>

<jsp:include page="footer.jsp" />