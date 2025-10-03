<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Ticket #${ticket.id} - TourMate</title>
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
      <div class="flex items-center justify-between text-white">
        <div>
          <div class="flex items-center mb-2">
            <a href="${pageContext.request.contextPath}/users/support-tickets"
               class="mr-4 p-2 hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
              <i class="fas fa-arrow-left text-xl"></i>
            </a>
            <h1 class="text-4xl font-bold">Ticket #${ticket.id}</h1>
          </div>
          <p class="text-white opacity-80">${ticket.subject}</p>
        </div>

        <div class="text-right">
          <div class="text-2xl font-bold">
            <c:choose>
              <c:when test='${ticket.status == "OPEN"}'>
                <span class="text-blue-200"><i class="fas fa-folder-open mr-2"></i>Open</span>
              </c:when>
              <c:when test='${ticket.status == "IN_PROGRESS"}'>
                <span class="text-yellow-200"><i class="fas fa-cog mr-2"></i>In Progress</span>
              </c:when>
              <c:when test='${ticket.status == "SOLVED"}'>
                <span class="text-green-200"><i class="fas fa-check-circle mr-2"></i>Solved</span>
              </c:when>
              <c:otherwise>
                <span class="text-gray-200"><i class="fas fa-times-circle mr-2"></i>Closed</span>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="text-white opacity-80">Priority: ${ticket.priority}</div>
        </div>
      </div>
    </div>
  </div>

  <div class="container mx-auto px-4 py-8 -mt-4">

    <!-- Flash Messages -->
    <c:if test="${not empty success}">
      <div class="max-w-4xl mx-auto mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg fade-in">
        <div class="flex items-center">
          <i class="fas fa-check-circle mr-2"></i>
          <span>${success}</span>
        </div>
      </div>
    </c:if>

    <c:if test="${not empty error}">
      <div class="max-w-4xl mx-auto mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg fade-in">
        <div class="flex items-center">
          <i class="fas fa-exclamation-circle mr-2"></i>
          <span>${error}</span>
        </div>
      </div>
    </c:if>

    <div class="max-w-4xl mx-auto">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- Main Content -->
        <div class="lg:col-span-2 space-y-6">

          <!-- Ticket Details -->
          <div class="glass-effect rounded-3xl shadow-2xl p-8 fade-in">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Ticket Details</h2>

            <div class="space-y-6">
              <!-- Subject -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Subject</label>
                <div class="p-4 bg-gray-50 rounded-lg">
                  <p class="text-gray-900 font-medium">${ticket.subject}</p>
                </div>
              </div>

              <!-- Description -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                <div class="p-4 bg-gray-50 rounded-lg">
                  <p class="text-gray-900 whitespace-pre-wrap">${ticket.description}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Replies Section -->
          <div class="glass-effect rounded-3xl shadow-2xl p-8 fade-in">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">Support Responses</h2>

            <div class="space-y-6">
              <!-- Agency Reply -->
              <c:if test="${not empty ticket.agencyReply}">
                <div class="bg-blue-50 border-l-4 border-blue-500 p-6 rounded-lg">
                  <div class="flex items-center mb-3">
                    <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center mr-3">
                      <i class="fas fa-building text-white text-sm"></i>
                    </div>
                    <div>
                      <h4 class="font-semibold text-blue-900">Agency Response</h4>
                      <p class="text-sm text-blue-700">Support Team</p>
                    </div>
                  </div>
                  <p class="text-blue-900 whitespace-pre-wrap">${ticket.agencyReply}</p>
                </div>
              </c:if>

              <!-- Admin Reply -->
              <c:if test="${not empty ticket.adminReply}">
                <div class="bg-purple-50 border-l-4 border-purple-500 p-6 rounded-lg">
                  <div class="flex items-center mb-3">
                    <div class="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center mr-3">
                      <i class="fas fa-user-shield text-white text-sm"></i>
                    </div>
                    <div>
                      <h4 class="font-semibold text-purple-900">Admin Response</h4>
                      <p class="text-sm text-purple-700">Administrator</p>
                    </div>
                  </div>
                  <p class="text-purple-900 whitespace-pre-wrap">${ticket.adminReply}</p>
                </div>
              </c:if>

              <!-- No Replies Yet -->
              <c:if test="${empty ticket.agencyReply && empty ticket.adminReply}">
                <div class="text-center py-12">
                  <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-clock text-2xl text-gray-400"></i>
                  </div>
                  <h3 class="text-lg font-semibold text-gray-700 mb-2">Awaiting Response</h3>
                  <p class="text-gray-500">Our support team will respond to your ticket soon.</p>
                </div>
              </c:if>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="lg:col-span-1 space-y-6">

          <!-- Ticket Info -->
          <div class="glass-effect rounded-2xl p-6 fade-in">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Ticket Information</h3>

            <div class="space-y-4">
              <div class="flex justify-between items-center py-2 border-b border-gray-200">
                <span class="text-sm text-gray-600">Ticket ID</span>
                <span class="font-medium text-gray-900">#${ticket.id}</span>
              </div>

              <div class="flex justify-between items-center py-2 border-b border-gray-200">
                <span class="text-sm text-gray-600">Status</span>
                <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full
                      <c:choose>
                        <c:when test='${ticket.status == "OPEN"}'>bg-blue-100 text-blue-800</c:when>
                        <c:when test='${ticket.status == "IN_PROGRESS"}'>bg-yellow-100 text-yellow-800</c:when>
                        <c:when test='${ticket.status == "SOLVED"}'>bg-green-100 text-green-800</c:when>
                        <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                      </c:choose>">
                  ${ticket.status}
                </span>
              </div>

              <div class="flex justify-between items-center py-2 border-b border-gray-200">
                <span class="text-sm text-gray-600">Priority</span>
                <span class="inline-flex px-2 py-1 text-xs font-bold rounded
                      <c:choose>
                        <c:when test='${ticket.priority == "URGENT"}'>bg-red-100 text-red-800</c:when>
                        <c:when test='${ticket.priority == "HIGH"}'>bg-orange-100 text-orange-800</c:when>
                        <c:when test='${ticket.priority == "MEDIUM"}'>bg-yellow-100 text-yellow-800</c:when>
                        <c:otherwise>bg-green-100 text-green-800</c:otherwise>
                      </c:choose>">
                  ${ticket.priority}
                </span>
              </div>

              <div class="flex justify-between items-center py-2 border-b border-gray-200">
                <span class="text-sm text-gray-600">Created</span>
                <span class="text-sm text-gray-900">
                  <!-- FIXED: Use fn:substring instead of fmt:formatDate -->
                  <c:out value="${fn:substring(ticket.createdAt, 0, 10)}" />
                </span>
              </div>

              <div class="flex justify-between items-center py-2">
                <span class="text-sm text-gray-600">Last Updated</span>
                <span class="text-sm text-gray-900">
                  <!-- FIXED: Use fn:substring instead of fmt:formatDate -->
                  <c:out value="${fn:substring(ticket.updatedAt, 0, 10)}" />
                </span>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="glass-effect rounded-2xl p-6 fade-in">
            <h3 class="text-lg font-bold text-gray-900 mb-4">Actions</h3>

            <div class="space-y-3">
              <c:if test="${ticket.status == 'OPEN'}">
                <a
                  href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/edit"
                  class="w-full inline-flex items-center justify-center px-4 py-3 bg-gradient-to-r from-yellow-500 to-orange-600 hover:from-yellow-600 hover:to-orange-700 text-white font-bold rounded-xl transition-all duration-300 transform hover:scale-105"
                >
                  <i class="fas fa-edit mr-2"></i>Edit Ticket
                </a>

                <form
                  method="POST"
                  action="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/close"
                  onsubmit="return confirm('Are you sure you want to close this ticket?')"
                >
                  <button
                    type="submit"
                    class="w-full inline-flex items-center justify-center px-4 py-3 bg-gray-600 hover:bg-gray-700 text-white font-bold rounded-xl transition-all duration-300"
                  >
                    <i class="fas fa-times-circle mr-2"></i>Close Ticket
                  </button>
                </form>

                <form
                  method="POST"
                  action="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/delete"
                  onsubmit="return confirm('Are you sure you want to delete this ticket? This action cannot be undone.')"
                >
                  <button
                    type="submit"
                    class="w-full inline-flex items-center justify-center px-4 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-xl transition-all duration-300"
                  >
                    <i class="fas fa-trash mr-2"></i>Delete Ticket
                  </button>
                </form>
              </c:if>

              <c:if test="${ticket.status == 'CLOSED' || ticket.status == 'SOLVED'}">
                <form
                  method="POST"
                  action="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/reopen"
                  onsubmit="return confirm('Are you sure you want to reopen this ticket?')"
                >
                  <button
                    type="submit"
                    class="w-full inline-flex items-center justify-center px-4 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl transition-all duration-300"
                  >
                    <i class="fas fa-redo mr-2"></i>Reopen Ticket
                  </button>
                </form>
              </c:if>

              <a
                href="${pageContext.request.contextPath}/users/support-tickets"
                class="w-full inline-flex items-center justify-center px-4 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold rounded-xl transition-all duration-300"
              >
                <i class="fas fa-list mr-2"></i>All Tickets
              </a>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

  <%@ include file="footer.jsp" %>

</body>
</html>
