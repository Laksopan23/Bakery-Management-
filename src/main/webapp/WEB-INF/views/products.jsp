<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container-fluid mt-4">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card shadow">
                <div class="card-header bg-gradient-primary text-white d-flex justify-content-between align-items-center py-3">
                    <h3 class="mb-0">
                        <i class="fas fa-bread-slice me-2"></i>Our Products
                    </h3>
                    <div class="d-flex align-items-center">
                        <span class="badge bg-light text-dark me-2">Total Products: ${products.size()}</span>
                        <a href="${pageContext.request.contextPath}/products/add" 
                           class="btn btn-light btn-sm">
                            <i class="fas fa-plus me-1"></i>Add New Product
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <c:out value="${successMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered align-middle">
                            <thead class="table-primary">
                                <tr>
                                    <th class="text-center" style="width: 5%">ID</th>
                                    <th style="width: 15%">Product</th>
                                    <th style="width: 20%">Description</th>
                                    <th style="width: 10%">Category</th>
                                    <th class="text-end" style="width: 10%">Price</th>
                                    <th class="text-center" style="width: 10%">Stock</th>
                                    <th class="text-center" style="width: 10%">Initial</th>
                                    <th class="text-center" style="width: 10%">Current</th>
                                    <th style="width: 10%">Image</th>
                                    <th class="text-center" style="width: 10%">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td class="text-center">
                                            <span class="badge bg-secondary">#${product.id}</span>
                                        </td>
                                        <td>
                                            <strong>${product.name}</strong>
                                        </td>
                                        <td>
                                            <small class="text-muted">${product.description}</small>
                                        </td>
                                        <td>
                                            <span class="badge bg-info text-white">${product.category}</span>
                                        </td>
                                        <td class="text-end">
                                            <span class="fw-bold text-primary">LKR ${product.price}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${product.quantityAvailable > 0 ? 'bg-success' : 'bg-danger'}">
                                                ${product.quantityAvailable}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary">${product.initialStock}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${product.currentStock > 0 ? 'bg-success' : 'bg-danger'}">
                                                ${product.currentStock}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <c:if test="${not empty product.image}">
                                                <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                                     alt="${product.name}" 
                                                     class="img-fluid rounded product-image" 
                                                     style="max-width: 100px; max-height: 100px; object-fit: contain;">
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/products/edit/${product.id}" 
                                                   class="btn btn-sm btn-outline-primary me-1" 
                                                   title="Edit Product">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/products/delete/${product.id}" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this product?')"
                                                   title="Delete Product">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<style>
    .table {
        font-size: 0.95rem;
        border-color: #dee2e6;
    }
    .table thead th {
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background-color: #007bff;
        color: white;
        border-bottom-width: 2px;
        white-space: nowrap;
    }
    .table tbody td {
        vertical-align: middle;
    }
    .text-end {
        text-align: right;
    }
    .text-center {
        text-align: center;
    }
    .btn-group .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
    .product-image {
        transition: transform 0.3s ease;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        border: 1px solid #dee2e6;
    }
    .product-image:hover {
        transform: scale(1.1);
        cursor: pointer;
    }
    .badge {
        font-size: 0.85rem;
        padding: 0.5em 0.75em;
        font-weight: 500;
    }
    .badge.bg-info {
        background-color: #17a2b8 !important;
    }
    .badge.bg-success {
        background-color: #28a745 !important;
    }
    .badge.bg-danger {
        background-color: #dc3545 !important;
    }
    .badge.bg-secondary {
        background-color: #6c757d !important;
    }
    .bg-gradient-primary {
        background: linear-gradient(45deg, #007bff, #0056b3);
    }
    .card {
        border: none;
        border-radius: 10px;
    }
    .card-header {
        border-radius: 10px 10px 0 0 !important;
    }
    .table-responsive {
        border-radius: 0 0 10px 10px;
    }
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.85rem;
        }
        .btn-group .btn {
            padding: 0.2rem 0.4rem;
            font-size: 0.75rem;
        }
        .product-image {
            max-width: 80px !important;
            max-height: 80px !important;
        }
        .badge {
            font-size: 0.75rem;
            padding: 0.4em 0.6em;
        }
    }
</style>