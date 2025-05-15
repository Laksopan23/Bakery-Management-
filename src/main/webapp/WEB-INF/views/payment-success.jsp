<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container-fluid mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-8">
            <div class="success-container text-center">
                <!-- Success Animation -->
                <div class="success-animation mb-4">
                    <div class="checkmark-circle">
                        <div class="background"></div>
                        <div class="checkmark draw"></div>
                    </div>
                </div>
                
                <!-- Success Message -->
                <h2 class="text-success fw-bold mb-3">Payment Successful!</h2>
                <p class="lead text-muted mb-4">Thank you for your purchase! Your order has been successfully placed.</p>

                <!-- Order Summary Card -->
                <div class="card shadow-sm order-card mb-5">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Order Summary</h4>
                        <span class="badge bg-light text-success">Order #${order.id}</span>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Order ID:</strong> ${order.id}</p>
                                <p class="mb-2"><strong>Product:</strong> ${order.productName}</p>
                                <p class="mb-2"><strong>Quantity:</strong> ${order.quantity}</p>
                                <p class="mb-2"><strong>Total Amount:</strong> 
                                    <span class="text-success">
                                        <fmt:formatNumber value="${order.quantity * order.price}" type="currency" currencyCode="LKR"/>
                                    </span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2"><strong>Payment Method:</strong> 
                                    <span class="badge bg-info payment-badge">${order.paymentMethod != null ? order.paymentMethod : "N/A"}</span>
                                </p>
                                <p class="mb-2"><strong>Order Date:</strong>
                                    <c:choose>
                                        <c:when test="${not empty order.orderDate}">
                                            <fmt:formatDate value="${order.orderDateAsDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                        </c:when>
                                        <c:otherwise>
                                            N/A
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="mb-2"><strong>Contact:</strong> ${order.phone}</p>
                                <p class="mb-2"><strong>Delivery Address:</strong> ${order.address}, ${order.city}, ${order.postalCode}</p>
                            </div>
                        </div>
                        <hr>
                        <p class="text-muted small mb-0">We will contact you shortly for delivery confirmation at <strong>${order.phone}</strong>.</p>
                    </div>
                </div>

                <!-- Delivery Status -->
                <div class="delivery-status mb-5">
                    <h4 class="mb-3">Estimated Delivery Status</h4>
                    <div class="progress" style="height: 35px; border-radius: 20px;">
                        <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" 
                             role="progressbar" 
                             style="width: 25%; transition: width 2s ease-in-out;" 
                             aria-valuenow="25" 
                             aria-valuemin="0" 
                             aria-valuemax="100">
                            <span class="text-white fw-bold">Order Confirmed (25%)</span>
                        </div>
                    </div>
                    <p class="mt-3 text-muted small">Estimated delivery within 3-5 business days. We'll keep you updated!</p>
                </div>

                <!-- Redirect Message -->
                <div class="redirect-message mt-4">
                    <p class="mb-3">Redirecting to your order history in <span id="countdown">5</span> seconds...</p>
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/orders/customer/history" class="btn btn-outline-primary btn-sm">
                            Go to Order History Now
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .success-container {
        padding: 2rem 0;
    }
    .success-animation {
        margin: 0 auto 30px;
        display: inline-block;
    }
    .checkmark-circle {
        width: 120px;
        height: 120px;
        position: relative;
        display: inline-block;
    }
    .checkmark-circle .background {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: linear-gradient(135deg, #28a745 0%, #218838 100%);
        position: absolute;
        opacity: 0.9;
        animation: pulse 1.5s infinite;
    }
    .checkmark-circle .checkmark {
        border-radius: 5px;
        display: block;
        width: 35px;
        height: 70px;
        border-width: 0 7px 7px 0;
        border-style: solid;
        border-color: white;
        position: absolute;
        top: 20px;
        left: 42px;
        transform: rotate(45deg);
        animation: checkmark 0.8s ease-in-out forwards;
    }
    @keyframes checkmark {
        0% { height: 0; width: 0; opacity: 0; }
        20% { height: 0; width: 35px; opacity: 1; }
        40% { height: 70px; width: 35px; opacity: 1; }
        100% { height: 70px; width: 35px; opacity: 1; }
    }
    @keyframes pulse {
        0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.5); }
        50% { transform: scale(1.05); box-shadow: 0 0 15px 5px rgba(40, 167, 69, 0.3); }
        100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.5); }
    }
    .order-card {
        border: none;
        border-radius: 15px;
        background: #fff;
        transition: all 0.3s ease;
    }
    .order-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
    }
    .order-card .card-header {
        border-radius: 15px 15px 0 0;
        padding: 1rem 1.5rem;
    }
    .order-card .card-body {
        padding: 1.5rem;
    }
    .order-card p {
        font-size: 1rem;
        color: #2c3e50;
    }
    .order-card strong {
        color: #2c3e50;
        font-weight: 600;
    }
    .badge {
        font-size: 0.85rem;
        padding: 0.5em 0.75em;
        border-radius: 20px;
        white-space: nowrap;
    }
    .payment-badge {
        background-color: #17a2b8 !important;
        color: white;
    }
    .progress {
        height: 35px;
        border-radius: 20px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        background: #e9ecef;
    }
    .progress-bar {
        font-size: 14px;
        line-height: 35px;
        transition: width 2s ease-in-out;
        background: linear-gradient(90deg, #17a2b8, #00c4b4);
    }
    .redirect-message {
        margin-top: 2rem;
    }
    .redirect-message .btn {
        border-radius: 20px;
        padding: 0.5rem 1.5rem;
        transition: all 0.3s ease;
    }
    .redirect-message .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }
    @media (max-width: 768px) {
        .success-container {
            padding: 1rem 0;
        }
        .checkmark-circle {
            width: 80px;
            height: 80px;
        }
        .checkmark-circle .background {
            width: 80px;
            height: 80px;
        }
        .checkmark-circle .checkmark {
            width: 25px;
            height: 50px;
            top: 12px;
            left: 28px;
        }
        .order-card .card-body {
            padding: 1rem;
        }
        .order-card p {
            font-size: 0.9rem;
        }
        .progress {
            height: 25px;
        }
        .progress-bar {
            font-size: 12px;
            line-height: 25px;
        }
        .redirect-message .btn {
            padding: 0.4rem 1rem;
        }
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Countdown timer for redirect
    let countdown = 5;
    const countdownElement = document.getElementById('countdown');
    const redirectInterval = setInterval(() => {
        countdown--;
        countdownElement.textContent = countdown;
        if (countdown <= 0) {
            clearInterval(redirectInterval);
            window.location.href = '${pageContext.request.contextPath}/orders/customer/history';
        }
    }, 1000);

    // Simulate progress bar update (optional, can be removed or adjusted with backend data)
    let progress = 25;
    const progressBar = document.querySelector('.progress-bar');
    if (progressBar) {
        const progressInterval = setInterval(() => {
            if (progress < 50) { // Adjust based on actual delivery stages
                progress += 5;
                progressBar.style.width = progress + '%';
                progressBar.setAttribute('aria-valuenow', progress);
                progressBar.innerHTML = `<span class="text-white fw-bold">Order Confirmed (${progress}%)</span>`;
            } else {
                clearInterval(progressInterval);
            }
        }, 1000);
    }
});
</script>

<jsp:include page="footer.jsp" />