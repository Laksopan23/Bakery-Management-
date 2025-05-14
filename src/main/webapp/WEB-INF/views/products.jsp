<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container-fluid mt-4">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-11">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Our Products</h3>
                    <span class="badge bg-light text-dark">Total Products: ${products.size()}</span>
                </div>
                <div class="card-body">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <c:out value="${successMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${errorMessage}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    
                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered align-middle">
                            <thead class="table-primary">
                                <tr>
                                    <th class="text-center" style="width: 4%">ID</th>
                                    <th style="width: 12%">Name</th>
                                    <th style="width: 25%">Description</th>
                                    <th style="width: 8%">Category</th>
                                    <th class="text-end" style="width: 8%">Price (LKR)</th>
                                    <th class="text-center" style="width: 7%">Qty Available</th>
                                    <th class="text-center" style="width: 7%">Initial Stock</th>
                                    <th class="text-center" style="width: 7%">Current Stock</th>
                                    <th style="width: 14%">Image</th>
                                    <th style="width: 12%">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr class="product-row">
                                        <td class="text-center fw-bold">#${product.id}</td>
                                        <td>
                                            <div class="product-name">${product.name}</div>
                                        </td>
                                        <td>
                                            <div class="product-description">${product.description}</div>
                                        </td>
                                        <td>
                                            <span class="badge bg-info category-badge">${product.category}</span>
                                        </td>
                                        <td class="text-end">
                                            <span class="price-badge">LKR ${product.price}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary">${product.quantityAvailable}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-primary">${product.initialStock}</span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${product.currentStock > 0 ? 'bg-success' : 'bg-danger'} stock-badge">
                                                ${product.currentStock}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${not empty product.image}">
                                                <div class="product-image-container">
                                                    <img src="${pageContext.request.contextPath}/resources/images/products/${product.image}" 
                                                         alt="${product.name}" 
                                                         class="img-fluid rounded product-image" 
                                                         style="max-width: 150px; max-height: 150px; object-fit: contain;">
                                                </div>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/products/edit/${product.id}" 
                                                   class="btn btn-sm btn-outline-primary me-1 action-btn">
                                                   <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/products/delete/${product.id}" 
                                                   class="btn btn-sm btn-outline-danger action-btn" 
                                                   onclick="return confirm('Are you sure you want to delete this product?')">
                                                   <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                        <a href="${pageContext.request.contextPath}/products/add" 
                           class="btn btn-primary">Add New Product</a>
                        <a href="${pageContext.request.contextPath}/" 
                           class="btn btn-secondary">Back to Home</a>
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
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        width: 100%;
    }
    .table thead th {
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background-color: #007bff;
        color: white;
        border-bottom-width: 2px;
        padding: 1rem;
        white-space: nowrap;
    }
    .table tbody td {
        vertical-align: middle;
        padding: 1rem;
    }
    .product-row {
        transition: all 0.3s ease;
    }
    .product-row:hover {
        background-color: #f8f9fa;
        transform: scale(1.01);
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .product-name {
        font-weight: 600;
        color: #2c3e50;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .product-description {
        color: #6c757d;
        font-size: 0.9rem;
        max-width: 300px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
    }
    .badge {
        font-size: 0.85rem;
        padding: 0.5em 0.75em;
        border-radius: 20px;
        white-space: nowrap;
    }
    .category-badge {
        background-color: #17a2b8 !important;
        color: white;
    }
    .price-badge {
        font-weight: 600;
        color: #28a745;
        font-size: 1.1rem;
        white-space: nowrap;
    }
    .stock-badge {
        font-weight: 600;
        padding: 0.6em 1em;
    }
    .product-image-container {
        padding: 0.5rem;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        text-align: center;
    }
    .product-image {
        transition: transform 0.3s ease;
        border-radius: 8px;
        max-width: 180px;
        max-height: 180px;
        object-fit: contain;
    }
    .product-image:hover {
        transform: scale(1.1);
        cursor: pointer;
    }
    .action-btn {
        transition: all 0.3s ease;
        border-radius: 20px;
        padding: 0.4rem 0.8rem;
        white-space: nowrap;
    }
    .action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }
    .btn-group {
        gap: 0.5rem;
    }
    @media (max-width: 1400px) {
        .product-description {
            max-width: 200px;
        }
        .product-image {
            max-width: 150px;
            max-height: 150px;
        }
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
            max-width: 100px !important;
            max-height: 100px !important;
        }
        .badge {
            font-size: 0.75rem;
            padding: 0.4em 0.6em;
        }
        .product-description {
            max-width: 150px;
        }
    }
</style>