<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">All Product Reviews</h3>
        </div>
        <div class="card-body">
            <!-- Search and Filter Section -->
            <form action="${pageContext.request.contextPath}/products/reviews" method="get" class="mb-4">
                <div class="row g-3">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="search" placeholder="Search by product or customer" value="${param.search}">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="rating">
                            <option value="">All Ratings</option>
                            <option value="5" ${param.rating == '5' ? 'selected' : ''}>5 Stars</option>
                            <option value="4" ${param.rating == '4' ? 'selected' : ''}>4 Stars</option>
                            <option value="3" ${param.rating == '3' ? 'selected' : ''}>3 Stars</option>
                            <option value="2" ${param.rating == '2' ? 'selected' : ''}>2 Stars</option>
                            <option value="1" ${param.rating == '1' ? 'selected' : ''}>1 Star</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="${pageContext.request.contextPath}/products/reviews" class="btn btn-secondary">Reset</a>
                    </div>
                </div>
            </form>

            <!-- Reviews List -->
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Customer</th>
                            <th>Rating</th>
                            <th>Comment</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="review" items="${reviews}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/products/view/${review.productId}">
                                        ${productNames[review.productId]}
                                    </a>
                                </td>
                                <td>${review.customerName}</td>
                                <td>
                                    <div class="rating-display">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="bi ${i <= review.rating ? 'bi-star-fill' : 'bi-star'} text-warning"></i>
                                        </c:forEach>
                                    </div>
                                </td>
                                <td>${review.comment}</td>
                                <td>
                                    <fmt:parseDate value="${review.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy HH:mm" />
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/products/review/delete" method="post" style="display:inline;">
                                        <input type="hidden" name="reviewId" value="${review.id}" />
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this review?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty reviews}">
                <div class="text-center mt-4">
                    <p class="text-muted">No reviews found.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<style>
.rating-display {
    color: #ffd700;
}
</style> 