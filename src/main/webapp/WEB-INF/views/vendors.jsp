<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    <h3 class="mb-0">Vendors</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty message}">
                        <div class="alert ${message.contains('Failed') || message.contains('not found') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show" role="alert">
                            <c:out value="${message}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Company</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="vendor" items="${vendors}">
                                    <tr>
                                        <td class="text-center">${vendor.id}</td>
                                        <td>${vendor.name}</td>
                                        <td>${vendor.email}</td>
                                        <td>${vendor.phone}</td>
                                        <td>${vendor.company}</td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/vendors/edit/${vendor.id}" class="btn btn-sm btn-outline-primary me-1">Edit</a>
                                                <a href="${pageContext.request.contextPath}/vendors/delete/${vendor.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                        <a href="${pageContext.request.contextPath}/vendors/add" class="btn btn-primary">Add Vendor</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
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
        background-color: #343a40;
        color: white;
        border-bottom-width: 2px;
    }
    .table tbody td {
        vertical-align: middle;
    }
    .text-center {
        text-align: center;
    }
    .btn-group .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.85rem;
        }
        .btn-group .btn {
            padding: 0.2rem 0.4rem;
            font-size: 0.75rem;
        }
    }
</style> 