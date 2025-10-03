<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Create Support Ticket - TourMate</title>
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
          <i class="fas fa-plus-circle text-2xl text-white"></i>
        </div>
        <h1 class="text-4xl font-bold mb-2">Create Support Ticket</h1>
        <p class="text-white opacity-80">Get help with your travel booking or account</p>
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
        <div class="inline-flex items-center justify-center w-12 h-12 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full mb-4">
          <i class="fas fa-headset text-white text-lg"></i>
        </div>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Submit Your Request</h2>
        <p class="text-gray-600">Describe your issue and we'll get back to you as soon as possible</p>
      </div>

      <!-- Support Form -->
      <form method="POST" action="${pageContext.request.contextPath}/users/support-tickets/create"
            id="supportForm" class="space-y-6">

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
            <option value="">Select Priority Level</option>
            <option value="LOW">Low - General inquiry</option>
            <option value="MEDIUM">Medium - Account or booking issue</option>
            <option value="HIGH">High - Payment or urgent booking problem</option>
            <option value="URGENT">Urgent - Critical issue requiring immediate attention</option>
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
            placeholder="Please provide detailed information about your issue. Include any relevant booking IDs, error messages, or steps you've already taken..."
          ></textarea>
          <div class="text-right text-sm text-gray-500 mt-1">
            <span id="charCount">0</span>/2000 characters
          </div>
        </div>

        <!-- Info Box -->
        <div class="bg-blue-50 border border-blue-200 rounded-xl p-4">
          <div class="flex">
            <i class="fas fa-info-circle text-blue-600 mt-1 mr-3"></i>
            <div class="text-sm text-blue-800">
              <p class="font-medium mb-1">Tips for faster resolution:</p>
              <ul class="list-disc list-inside space-y-1">
                <li>Include your booking ID or transaction number if applicable</li>
                <li>Describe what you were trying to do when the issue occurred</li>
                <li>Mention any error messages you received</li>
                <li>Attach screenshots if helpful (you can email them to support@tourmate.com)</li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex flex-col sm:flex-row gap-4 pt-6">
          <button
            type="submit"
            id="submitBtn"
            class="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-4 px-8 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
          >
            <i class="fas fa-paper-plane mr-2"></i>Submit Ticket
          </button>
          <a
            href="${pageContext.request.contextPath}/users/support-tickets"
            class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold py-4 px-8 rounded-xl transition-all duration-300 text-center"
          >
            <i class="fas fa-arrow-left mr-2"></i>Back to Tickets
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
    document.getElementById('supportForm').addEventListener('submit', function(e) {
      const subject = document.getElementById('subject').value.trim();
      const description = document.getElementById('description').value.trim();
      const priority = document.getElementById('priority').value;

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

      if (!priority) {
        e.preventDefault();
        alert('Please select a priority level');
        return;
      }

      // Disable submit button to prevent double submission
      document.getElementById('submitBtn').disabled = true;
      document.getElementById('submitBtn').innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Submitting...';
    });
  </script>

</body>
</html>
