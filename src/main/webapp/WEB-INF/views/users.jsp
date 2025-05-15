<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container-fluid mt-4">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-11">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Our Users</h3>
                    <span class="badge bg-light text-dark">Total Users: ${users.size()}</span>
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
                            <thead class="table-primary">
                                <tr>
                                    <th class="text-center" style="width: 5%">ID</th>
                                    <th style="width: 20%">Username</th>
                                    <th style="width: 30%">Email</th>
                                    <th style="width: 15%">Role</th>
                                    <th style="width: 20%">Password</th>
                                    <th style="width: 10%">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr class="user-row">
                                        <td class="text-center fw-bold">#${user.id}</td>
                                        <td>
                                            <div class="user-name">${user.username}</div>
                                        </td>
                                        <td>
                                            <div class="user-email">${user.email}</div>
                                        </td>
                                        <td>
                                            <span class="badge ${user.role == 'Admin' ? 'bg-danger' : 'bg-info'} role-badge">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${user.role == 'Admin'}">
                                                <div class="password-container">
                                                    <span class="password-hidden" id="password-${user.id}">********</span>
                                                    <button type="button" class="btn btn-sm btn-link text-decoration-none toggle-password" 
                                                            data-target="password-${user.id}" 
                                                            data-shown="password-shown-${user.id}">
                                                        <i class="fas fa-eye"></i> <span class="text">Show</span>
                                                    </button>
                                                    <span class="password-shown d-none" id="password-shown-${user.id}">${user.password}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${user.role != 'Admin'}">
                                                <span class="badge bg-secondary">********</span>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/users/edit/${user.id}" 
                                                   class="btn btn-sm btn-outline-primary me-1 action-btn">
                                                   <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/users/delete/${user.id}" 
                                                   class="btn btn-sm btn-outline-danger action-btn" 
                                                   onclick="return confirm('Are you sure you want to delete this user?')">
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
                        <a href="${pageContext.request.contextPath}/users/add" 
                           class="btn btn-primary">
                           <i class="fas fa-user-plus"></i> Add New User
                        </a>
                        <a href="${pageContext.request.contextPath}/" 
                           class="btn btn-secondary">
                           <i class="fas fa-home"></i> Back to Home
                        </a>
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
        const icon = this.querySelector('i');

        if (hiddenSpan.classList.contains('d-none')) {
            hiddenSpan.classList.remove('d-none');
            shownSpan.classList.add('d-none');
            textSpan.textContent = 'Show';
            icon.className = 'fas fa-eye';
        } else {
            hiddenSpan.classList.add('d-none');
            shownSpan.classList.remove('d-none');
            textSpan.textContent = 'Hide';
            icon.className = 'fas fa-eye-slash';
        }
    });
});
</script>

<jsp:include page="footer.jsp" />

<style>
    .table {
        font-size: 0.95rem;
        border-color: #dee2e6;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
    }
    .table thead th {
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        background-color: #007bff;
        color: white;
        border-bottom-width: 2px;
        padding: 1rem;
    }
    .table tbody td {
        vertical-align: middle;
        padding: 1rem;
    }
    .user-row {
        transition: all 0.3s ease;
    }
    .user-row:hover {
        background-color: #f8f9fa;
        transform: scale(1.01);
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .user-name {
        font-weight: 600;
        color: #2c3e50;
    }
    .user-email {
        color: #6c757d;
        font-size: 0.9rem;
    }
    .badge {
        font-size: 0.85rem;
        padding: 0.5em 0.75em;
        border-radius: 20px;
    }
    .role-badge {
        font-weight: 600;
    }
    .password-container {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .toggle-password {
        padding: 0;
        margin-left: 0.5rem;
        transition: all 0.3s ease;
    }
    .toggle-password .text {
        color: #007bff;
        transition: color 0.3s;
    }
    .toggle-password:hover .text {
        color: #0056b3;
        text-decoration: underline;
    }
    .action-btn {
        transition: all 0.3s ease;
        border-radius: 20px;
        padding: 0.4rem 0.8rem;
    }
    .action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }
    .btn-group {
        gap: 0.5rem;
    }
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.85rem;
        }
        .btn-group .btn {
            padding: 0.2rem 0.4rem;
            font-size: 0.75rem;
        }
        .badge {
            font-size: 0.75rem;
            padding: 0.4em 0.6em;
        }
        .password-container {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.3rem;
        }
    }
</style>