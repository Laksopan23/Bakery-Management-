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
                        <a href="${pageContext.request.contextPath}/orders/place/${product.id}" 
                           class="btn btn-success btn-lg w-100 mb-3">Order Now</a>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/products/customer" 
                       class="btn btn-outline-secondary w-100">Back to Products</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Reviews Section -->
    <div class="row mt-5">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-light">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">Customer Reviews</h3>
                        <c:if test="${not empty reviews}">
                            <div class="text-end">
                                <div class="h4 mb-0">
                                    <c:set var="avgRating" value="${0}" />
                                    <c:forEach var="review" items="${reviews}">
                                        <c:set var="avgRating" value="${avgRating + review.rating}" />
                                    </c:forEach>
                                    <c:set var="avgRating" value="${avgRating / reviews.size()}" />
                                    <fmt:formatNumber value="${avgRating}" pattern="0.0" />
                                    <i class="bi bi-star-fill text-warning"></i>
                                </div>
                                <small class="text-muted">${reviews.size()} reviews</small>
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Add Review Form -->
                    <form action="${pageContext.request.contextPath}/products/${product.id}/review" method="post" class="mb-4">
                        <div class="mb-3">
                            <label for="customerName" class="form-label">Your Name</label>
                            <input type="text" class="form-control" id="customerName" name="customerName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Rating</label>
                            <div class="rating">
                                <input type="radio" name="rating" value="5" id="5" required><label for="5">☆</label>
                                <input type="radio" name="rating" value="4" id="4"><label for="4">☆</label>
                                <input type="radio" name="rating" value="3" id="3"><label for="3">☆</label>
                                <input type="radio" name="rating" value="2" id="2"><label for="2">☆</label>
                                <input type="radio" name="rating" value="1" id="1"><label for="1">☆</label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="comment" class="form-label">Your Review</label>
                            <textarea class="form-control" id="comment" name="comment" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Submit Review</button>
                    </form>

                    <!-- Reviews List -->
                    <div class="reviews-list">
                        <c:if test="${empty reviews}">
                            <p class="text-muted text-center">No reviews yet. Be the first to review this product!</p>
                        </c:if>
                        <c:forEach var="review" items="${reviews}">
                            <p>Review by: '${review.customerName}' | Session: '${sessionScope.customerName}'</p>
                            <div class="review-item border-bottom pb-3 mb-3">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div>
                                        <h5 class="mb-0">${review.customerName}</h5>
                                        <div class="rating-display mb-2">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="bi ${i <= review.rating ? 'bi-star-fill' : 'bi-star'} text-warning"></i>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <small class="text-muted d-block mb-2">${review.createdAt}</small>
                                        <c:if test="${review.customerName eq sessionScope.customerName}">
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-outline-primary" 
                                                        onclick="editReview('${review.id}', '${review.customerName}', '${review.rating}', '${review.comment}')">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </button>
                                                <form action="${pageContext.request.contextPath}/products/review/delete" method="post" style="display:inline;">
                                                    <input type="hidden" name="reviewId" value="${review.id}" />
                                                    <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Are you sure you want to delete this review?')">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <p class="mb-0">${review.comment}</p>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<!-- Edit Review Modal (moved to end of file) -->
<div class="modal fade" id="editReviewModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Review</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editReviewForm" method="post">
                <input type="hidden" id="editReviewId" name="reviewId" />
                <input type="hidden" id="editProductId" name="productId" value="${product.id}" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Rating</label>
                        <div class="rating">
                            <input type="radio" name="rating" value="5" id="edit-5" required><label for="edit-5">☆</label>
                            <input type="radio" name="rating" value="4" id="edit-4"><label for="edit-4">☆</label>
                            <input type="radio" name="rating" value="3" id="edit-3"><label for="edit-3">☆</label>
                            <input type="radio" name="rating" value="2" id="edit-2"><label for="edit-2">☆</label>
                            <input type="radio" name="rating" value="1" id="edit-1"><label for="edit-1">☆</label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editComment" class="form-label">Your Review</label>
                        <textarea class="form-control" id="editComment" name="comment" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
    }
    .rating input {
        display: none;
    }
    .rating label {
        cursor: pointer;
        font-size: 2rem;
        color: #ddd;
        padding: 0 0.1em;
    }
    .rating input:checked ~ label,
    .rating label:hover,
    .rating label:hover ~ label {
        color: #ffd700;
    }
    .rating-display {
        font-size: 2rem;
    }
    .review-item:last-child {
        border-bottom: none !important;
    }
    .review-item {
        transition: background-color 0.2s ease;
    }
    .review-item:hover {
        background-color: #f8f9fa;
    }
</style>

<script>
function editReview(reviewId, customerName, rating, comment) {
    console.log('Raw rating value:', rating); // Debug log
    const modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
    const form = document.getElementById('editReviewForm');
    
    // Set form action to the correct endpoint
    form.action = `${pageContext.request.contextPath}/products/review/edit`;
    document.getElementById('editReviewId').value = reviewId;
    
    // Clear all rating radio buttons first
    for (let i = 1; i <= 5; i++) {
        const radio = document.getElementById(`edit-${i}`);
        if (radio) radio.checked = false;
    }
    // Trim and parse rating to ensure it's an integer
    const ratingValue = parseInt(String(rating).trim(), 10);
    const ratingInput = document.getElementById(`edit-${ratingValue}`);
    if (ratingInput) {
        ratingInput.checked = true;
    } else {
        console.log('Could not find radio for rating:', ratingValue);
    }
    
    // Set comment
    document.getElementById('editComment').value = comment;
    
    modal.show();
}
</script> 