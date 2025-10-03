<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Support Ticket - TourMate</title>
  <script src="https://cdn.tailwindcss.com"></script>
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
  </style>
</head>
<body class="bg-gray-50 min-h-screen">

  <!-- Header Section -->
  <div class="support-bg py-8">
    <div class="container mx-auto px-4">
      <div class="text-center text-white">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-white bg-opacity-20 rounded-full mb-4">
          <i class="fas fa-edit text-2xl text-white"></i>
        </div>
        <h1 class="text-4xl font-bold mb-2">Edit Support Ticket</h1>
        <p class="text-white opacity-80">Update your support request details</p>
      </div>
    </div>
  </div>

  <div class="container mx-auto px-4 py-8 -mt-4">

    <!-- Flash Messages -->
    <c:if test="${not empty success}">
      <div class="max-w-2xl mx-auto mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg fade-in">
        <div class="flex items-center">
          <i class="fas fa-check-circle mr-2"></i>
          <span>${success}</span>
        </div>
      </div>
    </c:if>

    <c:if test="${not empty error}">
      <div class="max-w-2xl mx-auto mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg fade-in">
        <div class="flex items-center">
          <i class="fas fa-exclamation-circle mr-2"></i>
          <span>${error}</span>
        </div>
      </div>
    </c:if>

    <!-- Main Form -->
    <div class="max-w-2xl mx-auto glass-effect rounded-3xl shadow-2xl p-8 fade-in">

      <!-- Form Header -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-12 h-12 bg-gradient-to-r from-yellow-500 to-orange-600 rounded-full mb-4">
          <i class="fas fa-edit text-white text-lg"></i>
        </div>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Update Ticket #${ticket.id}</h2>
        <p class="text-gray-600">Make changes to your support request</p>

        <!-- Current Status Badge -->
        <div class="mt-4">
          <span class="inline-flex px-3 py-1 text-sm font-semibold rounded-full
                <c:choose>
                  <c:when test='${ticket.status == "OPEN"}'>bg-blue-100 text-blue-800</c:when>
                  <c:when test='${ticket.status == "IN_PROGRESS"}'>bg-yellow-100 text-yellow-800</c:when>
                  <c:when test='${ticket.status == "SOLVED"}'>bg-green-100 text-green-800</c:when>
                  <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                </c:choose>">
            Status: ${ticket.status}
          </span>
        </div>
      </div>

      <!-- Support Form -->
      <form method="POST" action="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/update"
            id="editForm" class="space-y-6">

        <!-- Subject Field -->
        <div>
          <label for="subject" class="block text-sm font-medium text-gray-700 mb-2">
            <i class="fas fa-tag mr-2 text-blue-600"></i>Subject *
          </label>
          <input
            type="text"
            id="subject"
            name="subject"
            required
            maxlength="255"
            value="${ticket.subject}"
            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
            placeholder="Brief description of your issue"
          />
        </div>

        <!-- Priority Field -->
        <div>
          <label for="priority" class="block text-sm font-medium text-gray-700 mb-2">
            <i class="fas fa-exclamation-triangle mr-2 text-orange-600"></i>Priority *
          </label>
          <select
            id="priority"
            name="priority"
            required
            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
          >
            <option value="LOW" ${ticket.priority == 'LOW' ? 'selected' : ''}>Low - General inquiry</option>
            <option value="MEDIUM" ${ticket.priority == 'MEDIUM' ? 'selected' : ''}>Medium - Account or booking issue</option>
            <option value="HIGH" ${ticket.priority == 'HIGH' ? 'selected' : ''}>High - Payment or urgent booking problem</option>
            <option value="URGENT" ${ticket.priority == 'URGENT' ? 'selected' : ''}>Urgent - Critical issue requiring immediate attention</option>
          </select>
        </div>

        <!-- Description Field -->
        <div>
          <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
            <i class="fas fa-align-left mr-2 text-green-600"></i>Description *
          </label>
          <textarea
            id="description"
            name="description"
            required
            rows="6"
            maxlength="2000"
            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 resize-vertical"
            placeholder="Please provide detailed information about your issue..."
          >${ticket.description}</textarea>
          <div class="text-right text-sm text-gray-500 mt-1">
            <span id="charCount">${fn:length(ticket.description)}</span>/2000 characters
          </div>
        </div>

        <!-- Ticket Info Section - FIXED -->
        <div class="bg-gray-50 border border-gray-200 rounded-xl p-4">
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm">
            <div>
              <span class="font-medium text-gray-700">Created:</span>
              <span class="text-gray-600">
                <!-- FIXED: Use fn:substring instead of fmt:formatDate -->
                <c:out value="${fn:substring(ticket.createdAt, 0, 10)}" />
              </span>
            </div>
            <div>
              <span class="font-medium text-gray-700">Last Updated:</span>
              <span class="text-gray-600">
                <!-- FIXED: Use fn:substring instead of fmt:formatDate -->
                <c:out value="${fn:substring(ticket.updatedAt, 0, 10)}" />
              </span>
            </div>
          </div>
        </div>

        <!-- Warning Box -->
        <c:if test="${ticket.status != 'OPEN'}">
          <div class="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
            <div class="flex">
              <i class="fas fa-exclamation-triangle text-yellow-600 mt-1 mr-3"></i>
              <div class="text-sm text-yellow-800">
                <p class="font-medium mb-1">Notice:</p>
                <p>This ticket is currently ${ticket.status}. You can still update it, but the changes may not affect the current support process.</p>
              </div>
            </div>
          </div>
        </c:if>

        <!-- Action Buttons -->
        <div class="flex flex-col sm:flex-row gap-4 pt-6">
          <button
            type="submit"
            id="updateBtn"
            class="flex-1 bg-gradient-to-r from-yellow-500 to-orange-600 hover:from-yellow-600 hover:to-orange-700 text-white font-bold py-4 px-8 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
          >
            <i class="fas fa-save mr-2"></i>Update Ticket
          </button>
          <a
            href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}"
            class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold py-4 px-8 rounded-xl transition-all duration-300 text-center"
          >
            <i class="fas fa-arrow-left mr-2"></i>Back to Ticket
          </a>
        </div>

      </form>

    </div>
  </div>

  <%@ include file="footer.jsp" %>

  <script>
    // Character count for description
    const descriptionField = document.getElementById('description');
    const charCount = document.getElementById('charCount');

    descriptionField.addEventListener('input', function() {
      const count = this.value.length;
      charCount.textContent = count;

      if (count > 1800) {
        charCount.classList.add('text-red-500');
        charCount.classList.remove('text-gray-500');
      } else {
        charCount.classList.remove('text-red-500');
        charCount.classList.add('text-gray-500');
      }
    });

    // Form validation
    document.getElementById('editForm').addEventListener('submit', function(e) {
      const subject = document.getElementById('subject').value.trim();
      const description = document.getElementById('description').value.trim();

      if (subject.length < 5) {
        e.preventDefault();
        alert('Subject must be at least 5 characters long');
        return;
      }

      if (description.length < 20) {
        e.preventDefault();
        alert('Description must be at least 20 characters long');
        return;
      }

      // Disable submit button to prevent double submission
      document.getElementById('updateBtn').disabled = true;
      document.getElementById('updateBtn').innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Updating...';
    });
  </script>

</body>
</html>
