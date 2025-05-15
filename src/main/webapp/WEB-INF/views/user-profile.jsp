<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="header.jsp" />

<div class="container-fluid mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-12 col-xl-8">
            <div class="profile-container">
                <!-- Header -->
                <div class="card shadow-sm profile-header-card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">My Profile</h3>
                        <span class="badge bg-light text-primary">User #${user.id}</span>
                    </div>
                    <div class="card-body text-center">
                        <div class="profile-icon mb-3">
                            <i class="bi bi-person-circle" style="font-size: 5rem; color: #007bff;"></i>
                        </div>
                        <h4 class="fw-bold text-dark">${user.username}</h4>
                        <p class="text-muted">${user.email}</p>
                        <span class="badge ${user.role == 'Admin' ? 'bg-danger' : 'bg-info'} role-badge mb-3">
                            ${user.role}
                        </span>
                    </div>
                </div>

                <!-- Message Alerts -->
                <c:if test="${not empty message}">
                    <div class="alert ${message.contains('Failed') || message.contains('not found') || message.contains('Unauthorized') || message.contains('incorrect') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show mb-4" role="alert">
                        <c:out value="${message}" />
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Profile Details -->
                <div class="card shadow-sm profile-details-card mb-4">
                    <div class="card-header bg-light d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">Profile Details</h4>
                        <button class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="bi bi-pencil-square"></i> Edit Profile
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <p class="mb-2"><strong>Username:</strong> ${user.username}</p>
                                <p class="mb-2"><strong>Email:</strong> ${user.email}</p>
                            </div>
                            <div class="col-md-6 mb-3">
                                <p class="mb-2"><strong>Role:</strong> 
                                    <span class="badge ${user.role == 'Admin' ? 'bg-danger' : 'bg-info'} role-badge">
                                        ${user.role}
                                    </span>
                                </p>
                                <p class="mb-2"><strong>Password:</strong> 
                                    <span class="password-hidden" id="password-${user.id}">********</span>
                                    <button type="button" class="btn btn-sm btn-link text-decoration-none toggle-password" 
                                            data-target="password-${user.id}" 
                                            data-shown="password-shown-${user.id}">
                                        <i class="bi bi-eye"></i> <span class="text">Show</span>
                                    </button>
                                    <span class="password-shown d-none" id="password-shown-${user.id}">${user.password}</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Profile Modal -->
                <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="editProfileModalLabel">Edit Profile</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="editProfileForm" action="${pageContext.request.contextPath}/users/profile/update" method="post" novalidate>
                                    <input type="hidden" name="id" value="${user.id}">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username</label>
                                        <input type="text" class="form-control" id="username" name="username" 
                                               value="${user.username}" required pattern="[A-Za-z0-9]{3,20}"
                                               title="Username must be 3-20 characters long and contain only letters and numbers">
                                        <div class="invalid-feedback">
                                            Username must be 3-20 characters long and contain only letters and numbers
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="${user.email}" required 
                                               pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                               title="Please enter a valid email address">
                                        <div class="invalid-feedback">
                                            Please enter a valid email address
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="password" class="form-label">New Password (Optional)</label>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="Leave blank to keep current password"
                                               autocomplete="new-password" pattern=".{5,}" title="Password must be at least 5 characters long">
                                        <div class="invalid-feedback">
                                            Password must be at least 5 characters long
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Current Password</label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" 
                                               required autocomplete="current-password" pattern=".{5,}" title="Please enter your current password">
                                        <div class="invalid-feedback">
                                            Current password is required
                                        </div>
                                    </div>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Back to Home Button -->
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                        <i class="bi bi-house-door"></i> Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<style>
    .profile-container {
        padding: 2rem 0;
    }
    .profile-header-card, .profile-details-card {
        border: none;
        border-radius: 15px;
        transition: all 0.3s ease;
    }
    .profile-header-card:hover, .profile-details-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
    }
    .profile-header-card .card-header, .profile-details-card .card-header {
        border-radius: 15px 15px 0 0;
        padding: 1rem 1.5rem;
    }
    .profile-header-card .card-body, .profile-details-card .card-body {
        padding: 1.5rem;
    }
    .profile-icon {
        animation: fadeIn 1s ease-in-out;
    }
    @keyframes fadeIn {
        0% { opacity: 0; transform: scale(0.8); }
        100% { opacity: 1; transform: scale(1); }
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
    .btn {
        border-radius: 20px;
        transition: all 0.3s ease;
    }
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }
    .modal-content {
        border-radius: 15px;
    }
    .modal-header {
        border-radius: 15px 15px 0 0;
    }
    .form-control {
        border-radius: 10px;
        transition: all 0.3s ease;
    }
    .form-control:focus {
        box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
        border-color: #007bff;
    }
    @media (max-width: 768px) {
        .profile-container {
            padding: 1rem 0;
        }
        .profile-header-card .card-body, .profile-details-card .card-body {
            padding: 1rem;
        }
        .profile-icon i {
            font-size: 3rem;
        }
        .badge {
            font-size: 0.75rem;
            padding: 0.4em 0.6em;
        }
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Password toggle functionality
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
                icon.className = 'bi bi-eye';
            } else {
                hiddenSpan.classList.add('d-none');
                shownSpan.classList.remove('d-none');
                textSpan.textContent = 'Hide';
                icon.className = 'bi bi-eye-slash';
            }
        });
    });

    // Clear new password field and prevent autofill on modal open
    const modal = document.getElementById('editProfileModal');
    modal.addEventListener('shown.bs.modal', function() {
        document.getElementById('password').value = ''; // Clear new password field
        document.getElementById('currentPassword').value = ''; // Clear current password field initially
    });

    // Form validation with debug
    const form = document.getElementById('editProfileForm');
    form.addEventListener('submit', function(event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
            console.log("Form validation failed");
        } else {
            console.log("Form validated, submitting...");
        }
        form.classList.add('was-validated');
    });
});
</script>