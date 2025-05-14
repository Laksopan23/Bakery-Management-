<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white">
                    <h3 class="mb-0">Confirm Your Order</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="mb-4">
                        <h4>Product Details</h4>
                        <p><strong>Name:</strong> ${product.name}</p>
                        <p><strong>Category:</strong> ${product.category}</p>
                        <p><strong>Price:</strong> <fmt:formatNumber value="${product.price}" type="currency" currencyCode="LKR"/> per unit</p>
                        <p><strong>Available Stock:</strong> ${product.currentStock} units</p>
                        <p><strong>Selected Quantity:</strong> ${quantity} units</p>
                        <p><strong>Total Price:</strong> <fmt:formatNumber value="${product.price * quantity}" type="currency" currencyCode="LKR"/></p>
                    </div>

                    <form action="${pageContext.request.contextPath}/orders/confirm" method="post">
                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" name="userId" value="${userId}">
                        <input type="hidden" name="quantity" value="${quantity}">
                        <button type="submit" class="btn btn-success w-100">Confirm Order</button>
                    </form>
                    <a href="${pageContext.request.contextPath}/products/view/${product.id}" class="btn btn-outline-secondary w-100 mt-2">Back to Product</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />