<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card shadow">
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

                    <div class="row">
                        <!-- Product Image -->
                        <div class="col-md-4">
                            <c:choose>
                                <c:when test="${not empty product.image}">
                                    <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                         class="img-fluid rounded shadow" alt="${product.name}" 
                                         style="width: 100%; height: 300px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-light d-flex align-items-center justify-content-center rounded shadow" 
                                         style="height: 300px;">
                                        <i class="bi bi-basket" style="font-size: 5rem;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Order Details -->
                        <div class="col-md-8">
                            <div class="mb-4">
                                <h4 class="border-bottom pb-2">Product Details</h4>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><strong>Name:</strong> ${product.name}</p>
                                        <p><strong>Category:</strong> ${product.category}</p>
                                        <p><strong>Description:</strong> ${product.description}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>Unit Price:</strong> <fmt:formatNumber value="${product.price}" type="currency" currencyCode="LKR"/></p>
                                        <p><strong>Available Stock:</strong> ${product.currentStock} units</p>
                                        <p><strong>Selected Quantity:</strong> ${quantity} units</p>
                                        <p class="h5 text-success"><strong>Total Price:</strong> 
                                            <fmt:formatNumber value="${product.price * quantity}" type="currency" currencyCode="LKR"/>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Details Form -->
                            <div class="mb-4">
                                <h4 class="border-bottom pb-2">Delivery Details</h4>
                                <form action="${pageContext.request.contextPath}/orders/confirm" method="post" class="mt-4">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="hidden" name="userId" value="${userId}">
                                    <input type="hidden" name="quantity" value="${quantity}">
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="fullName" class="form-label">Full Name *</label>
                                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="phone" class="form-label">Phone Number *</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" required>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email Address *</label>
                                        <input type="email" class="form-control" id="email" name="email" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Delivery Address *</label>
                                        <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="city" class="form-label">City *</label>
                                            <input type="text" class="form-control" id="city" name="city" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="postalCode" class="form-label">Postal Code *</label>
                                            <input type="text" class="form-control" id="postalCode" name="postalCode" required>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="deliveryNotes" class="form-label">Delivery Notes (Optional)</label>
                                        <textarea class="form-control" id="deliveryNotes" name="deliveryNotes" rows="2" 
                                                  placeholder="Any special instructions for delivery..."></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="terms" required>
                                            <label class="form-check-label" for="terms">
                                                I agree to the terms and conditions of delivery
                                            </label>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-success btn-lg">
                                            <i class="bi bi-check-circle me-2"></i>Confirm Order
                                        </button>
                                        <a href="${pageContext.request.contextPath}/products/view/${product.id}" 
                                           class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left me-2"></i>Back to Product
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />