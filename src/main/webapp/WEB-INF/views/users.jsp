<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    <h3 class="mb-0">Our Users</h3>
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
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Password</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td class="text-center">${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>${user.role}</td>
                                        <td>
                                            <c:if test="${user.role == 'Admin'}">
                                                <span class="password-hidden" id="password-${user.id}">********</span>
                                                <button type="button" class="btn btn-sm btn-link text-decoration-none toggle-password" 
                                                        data-target="password-${user.id}" 
                                                        data-shown="password-shown-${user.id}">
                                                    <span class="text">Show</span>
                                                </button>
                                                <span class="password-shown d-none" id="password-shown-${user.id}">${user.password}</span>
                                            </c:if>
                                            <c:if test="${user.role != 'Admin'}">
                                                <span>********</span>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/users/edit/${user.id}" 
                                                   class="btn btn-sm btn-outline-primary me-1">Edit</a>
                                                <a href="${pageContext.request.contextPath}/users/delete/${user.id}" 
                                                   class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure?')">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                        <a href="${pageContext.request.contextPath}/users/add" class="btn btn-primary">Add New User</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Back to Home</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.querySelectorAll('.toggle-password').forEach(button => {
    button.addEventListener('click', function() {
        const targetId = this.getAttribute('data-target');
        const shownId = this.getAttribute('data-shown');
        const hiddenSpan = document.getElementById(targetId);
        const shownSpan = document.getElementById(shownId);
        const textSpan = this.querySelector('.text');

        if (hiddenSpan.classList.contains('d-none')) {
            hiddenSpan.classList.remove('d-none');
            shownSpan.classList.add('d-none');
            textSpan.textContent = 'Show';
        } else {
            hiddenSpan.classList.add('d-none');
            shownSpan.classList.remove('d-none');
            textSpan.textContent = 'Hide';
        }
    });
});
</script>

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
    .toggle-password {
        padding: 0;
        margin-left: 0.5rem;
    }
    .toggle-password .text {
        color: #007bff;
        transition: color 0.3s;
    }
    .toggle-password:hover .text {
        color: #0056b3;
        text-decoration: underline;
    }
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.85rem;
        }
        .btn-group .btn {
            padding: 0.2rem 0.4rem;
            font-size: 0.75rem;
        }
        .toggle-password {
            margin-left: 0.3rem;
        }
    }
</style>