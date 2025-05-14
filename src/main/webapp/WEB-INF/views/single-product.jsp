<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row">
        <div class="col-md-6">
            <c:choose>
                <c:when test="${not empty product.image}">
                    <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                         class="img-fluid rounded shadow" alt="${product.name}" style="max-height: 500px; width: 100%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <div class="bg-light d-flex align-items-center justify-content-center rounded shadow" style="height: 500px;">
                        <i class="bi bi-basket" style="font-size: 5rem;"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="card-title mb-3">${product.name}</h1>
                    <p class="text-muted mb-2">Category: ${product.category}</p>
                    <h3 class="text-primary mb-3">
                        <fmt:formatNumber value="${product.price}" type="currency" currencyCode="LKR"/>
                    </h3>
                    
                    <c:set var="inStock" value="${product.currentStock > 0}" />
                    <span class="badge ${inStock ? 'bg-success' : 'bg-danger'} mb-3" style="font-size: 1rem;">
                        ${inStock ? 'In Stock' : 'Out of Stock'}
                    </span>
                    
                    <p class="card-text mb-3">
                        <strong>Description:</strong><br>
                        ${product.description}
                    </p>
                    
                    <p class="card-text mb-3">
                        <strong>Current Stock:</strong> ${product.currentStock} units
                    </p>
                    
                    <c:if test="${inStock}">
                    <form action="${pageContext.request.contextPath}/orders/place/${product.id}" method="get">
                        <div class="mb-3">
                            <label for="quantity" class="form-label">Quantity:</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" min="1" max="${product.currentStock}" required>
                        </div>
                        <button type="submit" class="btn btn-success btn-lg w-100 mb-3">Order Now</button>
                    </form>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/products/customer" 
                       class="btn btn-outline-secondary w-100">Back to Products</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" /> 