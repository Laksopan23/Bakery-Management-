<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">Payment Options</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Order Summary -->
                    <div class="mb-4">
                        <h4 class="border-bottom pb-2">Order Summary</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Order ID:</strong> ${order.id}</p>
                                <p><strong>Product:</strong> ${product.name}</p>
                                <p><strong>Quantity:</strong> ${order.quantity}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Total Amount:</strong> 
                                    <span class="h5 text-success">
                                        <fmt:formatNumber value="${product.price * order.quantity}" type="currency" currencyCode="LKR"/>
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Methods -->
                    <form id="paymentForm" action="${pageContext.request.contextPath}/orders/process-payment" method="post" class="mt-4">
                        <input type="hidden" name="orderId" value="${order.id}">
                        
                        <h4 class="border-bottom pb-2 mb-3">Select Payment Method</h4>
                        
                        <div class="payment-methods">
                            <!-- Cash on Delivery -->
                            <div class="payment-option mb-3">
                                <input type="radio" class="btn-check" name="paymentMethod" id="cod" value="COD" required>
                                <label class="btn btn-outline-primary w-100 text-start p-3" for="cod">
                                    <i class="bi bi-cash-coin me-2"></i>
                                    <strong>Cash on Delivery</strong>
                                    <p class="mb-0 text-muted">Pay when you receive your order</p>
                                </label>
                            </div>

                            <!-- Credit/Debit Card -->
                            <div class="payment-option mb-3">
                                <input type="radio" class="btn-check" name="paymentMethod" id="card" value="CARD">
                                <label class="btn btn-outline-primary w-100 text-start p-3" for="card">
                                    <i class="bi bi-credit-card me-2"></i>
                                    <strong>Credit/Debit Card</strong>
                                    <p class="mb-0 text-muted">Pay securely with your card</p>
                                </label>
                            </div>

                            <!-- Mobile Payment -->
                            <div class="payment-option mb-3">
                                <input type="radio" class="btn-check" name="paymentMethod" id="mobile" value="MOBILE">
                                <label class="btn btn-outline-primary w-100 text-start p-3" for="mobile">
                                    <i class="bi bi-phone me-2"></i>
                                    <strong>Mobile Payment</strong>
                                    <p class="mb-0 text-muted">Pay using mobile banking apps</p>
                                </label>
                            </div>
                        </div>

                        <!-- Card Details (shown when card payment is selected) -->
                        <div id="cardDetails" class="mt-3" style="display: none;">
                            <div class="card">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label for="cardNumber" class="form-label">Card Number</label>
                                        <input type="text" class="form-control" id="cardNumber" name="cardNumber" 
                                               pattern="^(4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9]{2})[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$" 
                                               maxlength="16" placeholder="1234 5678 9012 3456"
                                               title="Please enter a valid Sri Lankan debit card number">
                                        <div class="form-text">Supported banks: Commercial Bank, Bank of Ceylon, People's Bank, Sampath Bank, Hatton National Bank</div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="expiryDate" class="form-label">Expiry Date</label>
                                            <input type="text" class="form-control" id="expiryDate" name="expiryDate" 
                                                   pattern="^(0[1-9]|1[0-2])\/([0-9]{2})$" placeholder="MM/YY"
                                                   title="Please enter a valid expiry date in MM/YY format (e.g., 12/25)"
                                                   maxlength="5">
                                            <div class="form-text">Format: MM/YY (e.g., 12/25)</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="cvv" class="form-label">CVV</label>
                                            <input type="text" class="form-control" id="cvv" name="cvv" 
                                                   pattern="^[0-9]{3}$" maxlength="3" placeholder="123"
                                                   title="Please enter a valid 3-digit CVV">
                                            <div class="form-text">3-digit security code</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Mobile Payment Details (shown when mobile payment is selected) -->
                        <div id="mobileDetails" class="mt-3" style="display: none;">
                            <div class="card">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label for="mobileNumber" class="form-label">Mobile Number</label>
                                        <input type="tel" class="form-control" id="mobileNumber" name="mobileNumber" 
                                               pattern="[0-9]{10}" maxlength="10" placeholder="Enter your mobile number">
                                    </div>
                                    <div class="mb-3">
                                        <label for="mobileBank" class="form-label">Select Mobile Bank</label>
                                        <select class="form-select" id="mobileBank" name="mobileBank">
                                            <option value="">Select a bank</option>
                                            <option value="dialog">Dialog</option>
                                            <option value="mobitel">Mobitel</option>
                                            <option value="hutch">Hutch</option>
                                            <option value="airtel">Airtel</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-lock me-2"></i>Proceed to Payment
                            </button>
                            <a href="${pageContext.request.contextPath}/orders/place/${product.id}?quantity=${order.quantity}" 
                               class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-2"></i>Back to Order Details
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Payment Form Validation Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('paymentForm');
    const cardDetails = document.getElementById('cardDetails');
    const mobileDetails = document.getElementById('mobileDetails');
    
    // Show/hide payment details based on selection
    document.querySelectorAll('input[name="paymentMethod"]').forEach(input => {
        input.addEventListener('change', function() {
            cardDetails.style.display = this.value === 'CARD' ? 'block' : 'none';
            mobileDetails.style.display = this.value === 'MOBILE' ? 'block' : 'none';
            
            // Reset validation
            form.classList.remove('was-validated');
        });
    });

    // Card number formatting and validation
    const cardNumber = document.getElementById('cardNumber');
    cardNumber.addEventListener('input', function() {
        // Remove non-numeric characters
        this.value = this.value.replace(/[^0-9]/g, '');
        
        // Validate card number using Luhn algorithm
        if (this.value.length === 16) {
            const isValid = validateLuhn(this.value);
            if (!isValid) {
                this.setCustomValidity('Invalid card number');
            } else {
                this.setCustomValidity('');
            }
        }
    });

    // Luhn algorithm for card validation
    function validateLuhn(cardNumber) {
        let sum = 0;
        let isEven = false;
        
        // Loop through values starting from the rightmost digit
        for (let i = cardNumber.length - 1; i >= 0; i--) {
            let digit = parseInt(cardNumber.charAt(i));
            
            if (isEven) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }
            
            sum += digit;
            isEven = !isEven;
        }
        
        return (sum % 10) === 0;
    }

    // Expiry date formatting and validation
    const expiryDate = document.getElementById('expiryDate');
    expiryDate.addEventListener('input', function() {
        // Remove any non-numeric characters
        let value = this.value.replace(/\D/g, '');
        
        // Format as MM/YY
        if (value.length >= 2) {
            // Ensure month is between 01-12
            let month = parseInt(value.substring(0, 2));
            if (month > 12) {
                month = 12;
            }
            value = (month < 10 ? '0' : '') + month + '/' + value.substring(2, 4);
        }
        
        this.value = value;

        // Validate expiry date
        if (value.length === 5) {
            const [month, year] = value.split('/');
            const currentDate = new Date();
            const currentYear = currentDate.getFullYear() % 100;
            const currentMonth = currentDate.getMonth() + 1;
            
            const expYear = parseInt(year);
            const expMonth = parseInt(month);
            
            if (expYear < currentYear || (expYear === currentYear && expMonth < currentMonth)) {
                this.setCustomValidity('Card has expired');
            } else if (expYear > currentYear + 10) {
                this.setCustomValidity('Invalid expiry year');
            } else {
                this.setCustomValidity('');
            }
        }
    });

    // CVV formatting and validation
    const cvv = document.getElementById('cvv');
    cvv.addEventListener('input', function() {
        // Remove any non-numeric characters
        this.value = this.value.replace(/\D/g, '');
        
        // Ensure exactly 3 digits
        if (this.value.length > 3) {
            this.value = this.value.slice(0, 3);
        }
        
        // Validate CVV
        if (this.value.length === 3) {
            this.setCustomValidity('');
        } else {
            this.setCustomValidity('CVV must be exactly 3 digits');
        }
    });

    // Mobile number formatting
    const mobileNumber = document.getElementById('mobileNumber');
    mobileNumber.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // Form validation
    form.addEventListener('submit', function(event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    });
});
</script>

<style>
.payment-option label {
    transition: all 0.3s ease;
}
.payment-option label:hover {
    background-color: #f8f9fa;
}
.btn-check:checked + label {
    background-color: #e9ecef;
    border-color: #0d6efd;
}
</style>

<jsp:include page="footer.jsp" /> 