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
                                <form id="orderForm" action="${pageContext.request.contextPath}/orders/confirm" method="post" class="mt-4" novalidate>
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <input type="hidden" name="userId" value="${userId}">
                                    <input type="hidden" name="quantity" value="${quantity}">
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="fullName" class="form-label">Full Name *</label>
                                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                                   pattern="[A-Za-z\s]{2,50}" required
                                                   title="Please enter a valid name (2-50 characters, letters and spaces only)">
                                            <div class="invalid-feedback">
                                                Please enter a valid name (2-50 characters, letters and spaces only)
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="phone" class="form-label">Phone Number *</label>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   pattern="[0-9]{10}" required
                                                   title="Please enter a valid 10-digit phone number">
                                            <div class="invalid-feedback">
                                                Please enter a valid 10-digit phone number
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email Address *</label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" required
                                               title="Please enter a valid email address">
                                        <div class="invalid-feedback">
                                            Please enter a valid email address
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Delivery Address *</label>
                                        <textarea class="form-control" id="address" name="address" rows="3" 
                                                  minlength="10" maxlength="200" required></textarea>
                                        <div class="invalid-feedback">
                                            Please enter a valid address (10-200 characters)
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="city" class="form-label">City *</label>
                                            <input type="text" class="form-control" id="city" name="city" 
                                                   pattern="[A-Za-z\s]{2,50}" required
                                                   title="Please enter a valid city name">
                                            <div class="invalid-feedback">
                                                Please enter a valid city name
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="postalCode" class="form-label">Postal Code *</label>
                                            <input type="text" class="form-control" id="postalCode" name="postalCode" 
                                                   pattern="[0-9]{5}" required
                                                   title="Please enter a valid 5-digit postal code">
                                            <div class="invalid-feedback">
                                                Please enter a valid 5-digit postal code
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="deliveryNotes" class="form-label">Delivery Notes (Optional)</label>
                                        <textarea class="form-control" id="deliveryNotes" name="deliveryNotes" rows="2" 
                                                  maxlength="200"
                                                  placeholder="Any special instructions for delivery..."></textarea>
                                        <div class="invalid-feedback">
                                            Delivery notes cannot exceed 200 characters
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="terms" required>
                                            <label class="form-check-label" for="terms">
                                                I agree to the terms and conditions of delivery
                                            </label>
                                            <div class="invalid-feedback">
                                                You must agree to the terms and conditions
                                            </div>
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

<!-- Form Validation Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('orderForm');
    
    form.addEventListener('submit', function(event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    });

    // Real-time validation for phone number
    const phoneInput = document.getElementById('phone');
    phoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value.length > 10) {
            this.value = this.value.slice(0, 10);
        }
    });

    // Real-time validation for postal code
    const postalCodeInput = document.getElementById('postalCode');
    postalCodeInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value.length > 5) {
            this.value = this.value.slice(0, 5);
        }
    });

    // Real-time validation for full name
    const fullNameInput = document.getElementById('fullName');
    fullNameInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^A-Za-z\s]/g, '');
    });

    // Real-time validation for city
    const cityInput = document.getElementById('city');
    cityInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^A-Za-z\s]/g, '');
    });
});
</script>

<jsp:include page="footer.jsp" />