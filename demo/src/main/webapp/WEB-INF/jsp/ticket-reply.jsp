<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Detect user type based on URL or session -->
<c:set var="isAgency" value="${fn:contains(pageContext.request.requestURI, '/agency/')}" />
<c:set var="baseUrl" value="${isAgency ? '/agency' : '/admin'}" />
<c:set var="userRole" value="${isAgency ? 'AGENCY' : 'ADMIN'}" />

<!-- Include appropriate navbar -->
<c:choose>
  <c:when test="${isAgency}">
    <%@ include file="navbar.jsp" %>
  </c:when>
  <c:otherwise>
    <%@ include file="admin-user-navbar.jsp" %>
  </c:otherwise>
</c:choose>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Reply to Ticket #${ticket.id} - TourMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    .support-bg {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .glass-effect {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .fade-in {
      animation: fadeIn 0.8s ease-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .char-counter {
      font-size: 0.75rem;
      color: #6b7280;
    }

    .char-counter.warning {
      color: #f59e0b;
    }

    .char-counter.danger {
      color: #ef4444;
    }
  </style>
</head>
<body class="bg-gray-50 min-h-screen">

  <!-- Header Section -->
  <div class="support-bg py-8">
    <div class="container mx-auto px-4">
      <div class="text-center text-white">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-white bg-opacity-20 rounded-full mb-4">
          <i class="fas fa-reply text-2xl text-white"></i>
        </div>
        <h1 class="text-4xl font-bold mb-2">
          <c:choose>
            <c:when test="${isAgency}">Agency - Reply to Support Ticket</c:when>
            <c:otherwise>Admin - Reply to Support Ticket</c:otherwise>
          </c:choose>
        </h1>
        <p class="text-white opacity-80">Ticket #${ticket.id} - ${ticket.subject}</p>
      </div>
    </div>
  </div>

  <div class="container mx-auto px-4 py-8 -mt-4">

    <!-- Flash Messages -->
    <c:if test="${not empty success}">
      <div class="mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg fade-in">
        <div class="flex items-center">
          <i class="fas fa-check-circle mr-2"></i>
          <span>${success}</span>
        </div>
      </div>
    </c:if>

    <c:if test="${not empty error}">
      <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg fade-in">
        <div class="flex items-center">
          <i class="fas fa-exclamation-circle mr-2"></i>
          <span>${error}</span>
        </div>
      </div>
    </c:if>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

      <!-- Left Column - Ticket Information -->
      <div class="lg:col-span-1 space-y-6">

        <!-- Ticket Details Card -->
        <div class="glass-effect rounded-2xl shadow-lg p-6 fade-in">
          <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
            <i class="fas fa-info-circle mr-2 text-blue-600"></i>
            Ticket Details
          </h2>

          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-500 mb-1">Ticket ID</label>
              <p class="text-gray-900 font-semibold">#${ticket.id}</p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-500 mb-1">Submitted By</label>
              <div class="flex items-center space-x-2">
                <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                  <i class="fas fa-user text-blue-600"></i>
                </div>
                <div>
                  <p class="text-gray-900 font-semibold">${ticket.user.username}</p>
                  <p class="text-sm text-gray-500">${ticket.user.email}</p>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-500 mb-1">Current Status</label>
              <c:choose>
                <c:when test="${ticket.status == 'OPEN'}">
                  <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-blue-100 text-blue-800">
                    <i class="fas fa-folder-open mr-1"></i>Open
                  </span>
                </c:when>
                <c:when test="${ticket.status == 'IN_PROGRESS'}">
                  <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-yellow-100 text-yellow-800">
                    <i class="fas fa-cog mr-1"></i>In Progress
                  </span>
                </c:when>
                <c:when test="${ticket.status == 'SOLVED'}">
                  <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-green-100 text-green-800">
                    <i class="fas fa-check-circle mr-1"></i>Solved
                  </span>
                </c:when>
                <c:when test="${ticket.status == 'CLOSED'}">
                  <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full bg-gray-100 text-gray-800">
                    <i class="fas fa-times-circle mr-1"></i>Closed
                  </span>
                </c:when>
              </c:choose>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-500 mb-1">Priority</label>
              <span class="inline-flex px-3 py-1 text-sm font-bold rounded
                    <c:choose>
                      <c:when test='${ticket.priority == "URGENT"}'>bg-red-100 text-red-800</c:when>
                      <c:when test='${ticket.priority == "HIGH"}'>bg-orange-100 text-orange-800</c:when>
                      <c:when test='${ticket.priority == "MEDIUM"}'>bg-yellow-100 text-yellow-800</c:when>
                      <c:otherwise>bg-green-100 text-green-800</c:otherwise>
                    </c:choose>">
                <i class="fas fa-exclamation-triangle mr-1"></i>${ticket.priority}
              </span>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-500 mb-1">Created</label>
              <p class="text-gray-900 text-sm">
                <i class="fas fa-clock mr-1 text-gray-400"></i>
                <c:out value="${fn:substring(ticket.createdAt, 0, 19)}" />
              </p>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-500 mb-1">Last Updated</label>
              <p class="text-gray-900 text-sm">
                <i class="fas fa-sync-alt mr-1 text-gray-400"></i>
                <c:out value="${fn:substring(ticket.updatedAt, 0, 19)}" />
              </p>
            </div>
          </div>
        </div>

        <!-- Quick Actions -->
        <div class="glass-effect rounded-2xl shadow-lg p-6 fade-in">
          <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
            <i class="fas fa-bolt mr-2 text-yellow-600"></i>
            Quick Actions
          </h2>

          <div class="space-y-3">
            <a href="${pageContext.request.contextPath}${baseUrl}/tickets"
               class="block w-full px-4 py-2 text-center bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors duration-200">
              <i class="fas fa-arrow-left mr-2"></i>Back to Tickets
            </a>
          </div>
        </div>
      </div>

      <!-- Right Column - Ticket & Reply Form -->
      <div class="lg:col-span-2 space-y-6">

        <!-- Original Ticket Message -->
        <div class="glass-effect rounded-2xl shadow-lg p-6 fade-in">
          <div class="flex items-start space-x-4">
            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
              <i class="fas fa-user text-blue-600 text-lg"></i>
            </div>
            <div class="flex-1">
              <div class="flex items-center justify-between mb-2">
                <div>
                  <h3 class="text-lg font-bold text-gray-900">${ticket.user.username}</h3>
                  <p class="text-sm text-gray-500">
                    <i class="fas fa-clock mr-1"></i>
                    <c:out value="${fn:substring(ticket.createdAt, 0, 19)}" />
                  </p>
                </div>
                <span class="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded">Original Ticket</span>
              </div>
              <div class="bg-gray-50 rounded-lg p-4">
                <h4 class="font-semibold text-gray-900 mb-2">${ticket.subject}</h4>
                <p class="text-gray-700 whitespace-pre-wrap">${ticket.description}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- ✅ Existing Replies (Admin & Agency) -->
        <div class="glass-effect rounded-2xl shadow-lg p-6 fade-in">
          <h2 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
            <i class="fas fa-comments mr-2 text-purple-600"></i>
            Support Responses
          </h2>

          <div class="space-y-4">
            <!-- Admin Reply -->
            <c:if test="${not empty ticket.adminReply}">
              <div class="bg-purple-50 border-l-4 border-purple-500 rounded-lg p-4">
                <div class="flex items-start space-x-3">
                  <div class="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-user-shield text-purple-600"></i>
                  </div>
                  <div class="flex-1">
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm font-semibold text-gray-900">Admin Response</span>
                      <span class="text-xs bg-purple-100 text-purple-800 px-2 py-1 rounded">Official</span>
                    </div>
                    <p class="text-gray-700 text-sm whitespace-pre-wrap">${ticket.adminReply}</p>
                  </div>
                </div>
              </div>
            </c:if>

            <!-- Agency Reply -->
            <c:if test="${not empty ticket.agencyReply}">
              <div class="bg-green-50 border-l-4 border-green-500 rounded-lg p-4">
                <div class="flex items-start space-x-3">
                  <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-building text-green-600"></i>
                  </div>
                  <div class="flex-1">
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm font-semibold text-gray-900">Agency Response</span>
                      <span class="text-xs bg-green-100 text-green-800 px-2 py-1 rounded">Travel Agency</span>
                    </div>
                    <p class="text-gray-700 text-sm whitespace-pre-wrap">${ticket.agencyReply}</p>
                  </div>
                </div>
              </div>
            </c:if>

            <!-- No Replies Yet -->
            <c:if test="${empty ticket.adminReply and empty ticket.agencyReply}">
              <div class="text-center py-8 text-gray-500 bg-gray-50 rounded-lg">
                <i class="fas fa-inbox text-4xl mb-3"></i>
                <p>No responses yet. Add your reply below.</p>
              </div>
            </c:if>
          </div>
        </div>

        <!-- ✅ Combined Reply & Status Update Form -->
        <div class="glass-effect rounded-2xl shadow-lg p-6 fade-in">
          <h2 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <i class="fas fa-reply mr-2 text-green-600"></i>
            <c:choose>
              <c:when test="${(isAgency and not empty ticket.agencyReply) or (!isAgency and not empty ticket.adminReply)}">
                Update Your Reply & Status
              </c:when>
              <c:otherwise>
                Add Reply & Update Status
              </c:otherwise>
            </c:choose>
          </h2>

          <form method="POST" action="${pageContext.request.contextPath}${baseUrl}/tickets/reply/${ticket.id}" id="replyForm">

            <!-- Status Selector -->
            <div class="mb-6">
              <label for="status" class="block text-sm font-medium text-gray-700 mb-2">
                <i class="fas fa-tasks mr-1"></i>
                Update Ticket Status <span class="text-red-500">*</span>
              </label>
              <select
                id="status"
                name="status"
                required
                class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                <option value="OPEN" ${ticket.status == 'OPEN' ? 'selected' : ''}>
                  🔵 Open - Waiting for response
                </option>
                <option value="IN_PROGRESS" ${ticket.status == 'IN_PROGRESS' ? 'selected' : ''}>
                  🟡 In Progress - Working on it
                </option>
                <option value="SOLVED" ${ticket.status == 'SOLVED' ? 'selected' : ''}>
                  🟢 Solved - Issue resolved
                </option>
                <option value="CLOSED" ${ticket.status == 'CLOSED' ? 'selected' : ''}>
                  ⚫ Closed - No further action needed
                </option>
              </select>
              <p class="text-xs text-gray-500 mt-1">
                <i class="fas fa-info-circle mr-1"></i>
                Select the current status of this ticket
              </p>
            </div>

            <!-- Reply Textarea -->
            <div class="mb-6">
              <label for="reply" class="block text-sm font-medium text-gray-700 mb-2">
                <i class="fas fa-comment-dots mr-1"></i>
                Your Reply Message <span class="text-red-500">*</span>
              </label>
              <textarea
                id="reply"
                name="reply"
                rows="8"
                required
                maxlength="2000"
                placeholder="Type your detailed response here... (Min 10 characters, Max 2000 characters)"
                class="w-full border border-gray-300 rounded-lg px-4 py-3 focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                oninput="updateCharCount()"
              ><c:choose><c:when test="${isAgency}">${ticket.agencyReply}</c:when><c:otherwise>${ticket.adminReply}</c:otherwise></c:choose></textarea>
              <div class="flex justify-between items-center mt-2">
                <span class="text-xs text-gray-500">
                  <i class="fas fa-lightbulb mr-1"></i>
                  Be professional, clear, and provide actionable solutions
                </span>
                <span id="charCount" class="char-counter">0 / 2000</span>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-3">
              <button
                type="submit"
                class="flex-1 px-6 py-3 bg-gradient-to-r from-green-500 to-green-600 text-white font-semibold rounded-lg hover:from-green-600 hover:to-green-700 transform hover:scale-105 transition-all duration-300 shadow-lg"
              >
                <i class="fas fa-paper-plane mr-2"></i>
                <c:choose>
                  <c:when test="${(isAgency and not empty ticket.agencyReply) or (!isAgency and not empty ticket.adminReply)}">
                    Update Reply & Status
                  </c:when>
                  <c:otherwise>
                    Send Reply & Update Status
                  </c:otherwise>
                </c:choose>
              </button>
              <button
                type="button"
                onclick="confirmCancel()"
                class="px-6 py-3 bg-gray-200 text-gray-700 font-semibold rounded-lg hover:bg-gray-300 transition-colors duration-200"
              >
                <i class="fas fa-times mr-2"></i>Cancel
              </button>
            </div>

            <!-- Help Text -->
            <div class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
              <p class="text-sm text-blue-800">
                <i class="fas fa-info-circle mr-2"></i>
                <strong>Note:</strong> When you submit this form, both your reply and the selected status will be saved to the database.
                The ticket status will be updated and the user will see your response.
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <%@ include file="footer.jsp" %>

  <!-- JavaScript -->
  <script>
    // Character counter for textarea
    function updateCharCount() {
      const textarea = document.getElementById('reply');
      const charCount = document.getElementById('charCount');
      const currentLength = textarea.value.length;
      const maxLength = 2000;

      charCount.textContent = currentLength + ' / ' + maxLength;

      // Color coding based on usage
      charCount.classList.remove('warning', 'danger');
      if (currentLength > maxLength * 0.9) {
        charCount.classList.add('danger');
      } else if (currentLength > maxLength * 0.75) {
        charCount.classList.add('warning');
      }
    }

    // Confirm before canceling
    function confirmCancel() {
      const replyText = document.getElementById('reply').value.trim();
      const originalReply = '<c:choose><c:when test="${isAgency}">${ticket.agencyReply}</c:when><c:otherwise>${ticket.adminReply}</c:otherwise></c:choose>'.trim();

      if (replyText !== originalReply && replyText.length > 0) {
        Swal.fire({
          title: 'Discard Changes?',
          text: 'Your unsaved changes will be lost if you leave this page.',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonColor: '#d33',
          cancelButtonColor: '#3085d6',
          confirmButtonText: 'Yes, discard',
          cancelButtonText: 'Keep editing'
        }).then((result) => {
          if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}${baseUrl}/tickets';
          }
        });
      } else {
        window.location.href = '${pageContext.request.contextPath}${baseUrl}/tickets';
      }
    }

    // Form validation
    document.getElementById('replyForm').addEventListener('submit', function(e) {
      const reply = document.getElementById('reply').value.trim();
      const status = document.getElementById('status').value;

      if (reply.length === 0) {
        e.preventDefault();
        Swal.fire({
          icon: 'error',
          title: 'Empty Reply',
          text: 'Please enter your reply message before submitting.',
          confirmButtonColor: '#3085d6'
        });
        return false;
      }

      if (reply.length < 10) {
        e.preventDefault();
        Swal.fire({
          icon: 'warning',
          title: 'Reply Too Short',
          text: 'Your reply should be at least 10 characters long to provide meaningful assistance.',
          confirmButtonColor: '#3085d6'
        });
        return false;
      }

      if (!status) {
        e.preventDefault();
        Swal.fire({
          icon: 'error',
          title: 'Status Required',
          text: 'Please select a ticket status.',
          confirmButtonColor: '#3085d6'
        });
        return false;
      }

      // Show loading indicator
      Swal.fire({
        title: 'Saving Changes...',
        text: 'Please wait while we update the ticket.',
        allowOutsideClick: false,
        didOpen: () => {
          Swal.showLoading();
        }
      });
    });

    // Initialize char count on page load
    window.addEventListener('DOMContentLoaded', function() {
      updateCharCount();
    });

    // Prevent accidental navigation away
    let formChanged = false;
    const replyField = document.getElementById('reply');
    const statusField = document.getElementById('status');
    const originalReply = replyField.value;
    const originalStatus = statusField.value;

    replyField.addEventListener('input', function() {
      formChanged = (this.value !== originalReply);
    });

    statusField.addEventListener('change', function() {
      formChanged = formChanged || (this.value !== originalStatus);
    });

    window.addEventListener('beforeunload', function(e) {
      if (formChanged) {
        e.preventDefault();
        e.returnValue = '';
      }
    });

    // Clear flag on form submit
    document.getElementById('replyForm').addEventListener('submit', function() {
      formChanged = false;
    });
  </script>

</body>
</html>
