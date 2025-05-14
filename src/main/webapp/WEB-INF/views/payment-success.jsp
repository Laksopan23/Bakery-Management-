<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8 text-center">
            <div class="success-animation">
                <div class="checkmark-circle">
                    <div class="checkmark draw"></div>
                </div>
            </div>
            <h2 class="mt-4 text-success">Payment Successful!</h2>
            <div class="alert alert-success mt-3">
                <h4>Order Confirmed</h4>
                <p>Order ID: <strong>${order.id}</strong></p>
                <p>We will contact you shortly at <strong>${order.phone}</strong> for delivery confirmation.</p>
            </div>
            <div class="delivery-status mt-4">
                <h4>Estimated Delivery Status</h4>
                <div class="progress mt-3">
                    <div class="progress-bar progress-bar-striped progress-bar-animated" 
                         role="progressbar" 
                         style="width: 25%" 
                         aria-valuenow="25" 
                         aria-valuemin="0" 
                         aria-valuemax="100">
                        Order Confirmed
                    </div>
                </div>
            </div>
            <div class="mt-4">
                <p>Redirecting to your order history...</p>
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.success-animation {
    margin: 50px auto;
}

.checkmark-circle {
    width: 80px;
    height: 80px;
    position: relative;
    display: inline-block;
    vertical-align: top;
    margin-right: 20px;
}

.checkmark-circle .background {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: #4CAF50;
    position: absolute;
}

.checkmark-circle .checkmark {
    border-radius: 5px;
    display: block;
    width: 25px;
    height: 50px;
    border-width: 0 5px 5px 0;
    border-style: solid;
    border-color: white;
    position: absolute;
    top: 10px;
    left: 30px;
    transform: rotate(45deg);
    animation: checkmark 0.8s ease-in-out forwards;
}

@keyframes checkmark {
    0% {
        height: 0;
        width: 0;
        opacity: 1;
    }
    20% {
        height: 0;
        width: 25px;
        opacity: 1;
    }
    40% {
        height: 50px;
        width: 25px;
        opacity: 1;
    }
    100% {
        height: 50px;
        width: 25px;
        opacity: 1;
    }
}

.progress {
    height: 25px;
    border-radius: 12px;
}

.progress-bar {
    font-size: 14px;
    line-height: 25px;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Redirect after 5 seconds
    setTimeout(function() {
        window.location.href = '${pageContext.request.contextPath}/orders/customer/history';
    }, 5000);
});
</script>

<jsp:include page="footer.jsp" /> 