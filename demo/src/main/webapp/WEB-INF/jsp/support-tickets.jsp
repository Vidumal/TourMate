<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Support Tickets - TourMate</title>
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
    nav {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
        color: white !important;
    }

    nav a {
        color: white !important;
    }

    nav a:hover {
        color: #fbbf24 !important; /* Yellow on hover */
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
          <i class="fas fa-headset text-2xl text-white"></i>
        </div>
        <h1 class="text-4xl font-bold mb-2">My Support Tickets</h1>
        <p class="text-white opacity-80">Track your support requests and get help</p>
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

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-ticket-alt text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${totalTickets}</h3>
        <p class="text-gray-600 text-sm">Total Tickets</p>
      </div>

      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-green-500 to-blue-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-folder-open text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${openCount}</h3>
        <p class="text-gray-600 text-sm">Open Tickets</p>
      </div>

      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-yellow-500 to-orange-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-cog text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${solvedCount}</h3>
        <p class="text-gray-600 text-sm">Solved</p>
      </div>

      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-gray-500 to-gray-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-check-circle text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${closedCount}</h3>
        <p class="text-gray-600 text-sm">Closed</p>
      </div>
    </div>

    <!-- Main Content -->
    <div class="glass-effect rounded-3xl shadow-2xl p-8 fade-in">

      <!-- Header with Create Button -->
      <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-8 gap-4">
        <div>
          <h2 class="text-2xl font-bold text-gray-900 mb-2">Support Requests</h2>
          <p class="text-gray-600">Manage and track your support tickets</p>
        </div>

        <!-- CREATE NEW TICKET BUTTON - Maps to create-support-ticket.jsp -->
        <a
          href="${pageContext.request.contextPath}/users/support-tickets/create"
          class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg"
        >
          <i class="fas fa-plus mr-2"></i>Create New Ticket
        </a>
      </div>

      <!-- Search and Filter Controls -->
      <div class="flex flex-col lg:flex-row lg:justify-between lg:items-center mb-6 gap-4">
        <form method="GET" action="${pageContext.request.contextPath}/users/support-tickets" class="flex flex-col sm:flex-row gap-4">
          <!-- Search Input -->
          <div class="relative">
            <input
              type="text"
              name="search"
              value="${searchQuery}"
              placeholder="Search tickets..."
              class="w-full sm:w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
          </div>

          <!-- Status Filter -->
          <select
            name="status"
            onchange="this.form.submit()"
            class="appearance-none bg-white border border-gray-300 rounded-lg px-4 py-2 pr-8 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          >
            <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>All Status</option>
            <option value="open" ${statusFilter == 'open' ? 'selected' : ''}>Open</option>
            <option value="in_progress" ${statusFilter == 'in_progress' ? 'selected' : ''}>In Progress</option>
            <option value="solved" ${statusFilter == 'solved' ? 'selected' : ''}>Solved</option>
            <option value="closed" ${statusFilter == 'closed' ? 'selected' : ''}>Closed</option>
          </select>

          <!-- Priority Filter -->
          <select
            name="priority"
            onchange="this.form.submit()"
            class="appearance-none bg-white border border-gray-300 rounded-lg px-4 py-2 pr-8 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          >
            <option value="all" ${priorityFilter == 'all' ? 'selected' : ''}>All Priority</option>
            <option value="urgent" ${priorityFilter == 'urgent' ? 'selected' : ''}>Urgent</option>
            <option value="high" ${priorityFilter == 'high' ? 'selected' : ''}>High</option>
            <option value="medium" ${priorityFilter == 'medium' ? 'selected' : ''}>Medium</option>
            <option value="low" ${priorityFilter == 'low' ? 'selected' : ''}>Low</option>
          </select>

          <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200">
            <i class="fas fa-search mr-1"></i>Filter
          </button>
        </form>
      </div>

      <!-- Tickets List -->
      <div class="space-y-4">
        <c:choose>
          <c:when test="${not empty tickets}">
            <c:forEach var="ticket" items="${tickets}">
              <div class="bg-white border border-gray-200 rounded-xl p-6 hover:shadow-md transition-shadow duration-200">
                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">

                  <!-- Ticket Info -->
                  <div class="flex-1">
                    <div class="flex items-start gap-4">
                      <!-- Priority Icon -->
                      <div class="flex-shrink-0">
                        <div class="w-12 h-12 rounded-full flex items-center justify-center
                              <c:choose>
                                <c:when test='${ticket.priority == "URGENT"}'>bg-red-100 text-red-600</c:when>
                                <c:when test='${ticket.priority == "HIGH"}'>bg-orange-100 text-orange-600</c:when>
                                <c:when test='${ticket.priority == "MEDIUM"}'>bg-yellow-100 text-yellow-600</c:when>
                                <c:otherwise>bg-green-100 text-green-600</c:otherwise>
                              </c:choose>">
                          <i class="fas fa-exclamation-triangle"></i>
                        </div>
                      </div>

                      <!-- Ticket Details -->
                      <div class="flex-1 min-w-0">
                        <div class="flex items-center gap-2 mb-1">
                          <h3 class="text-lg font-semibold text-gray-900">
                            <a href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}"
                               class="hover:text-blue-600 transition-colors duration-200">
                              ${ticket.subject}
                            </a>
                          </h3>
                        </div>

                        <p class="text-gray-600 text-sm mb-3 line-clamp-2">
                          ${ticket.description}
                        </p>

                        <!-- In the date formatting section, keep your current fix: -->
                        <div class="flex flex-wrap items-center gap-4 text-sm text-gray-500">
                          <span class="flex items-center">
                            <i class="fas fa-hashtag mr-1"></i>
                            #${ticket.id}
                          </span>
                          <span class="flex items-center">
                            <i class="fas fa-clock mr-1"></i>
                            <!-- Your fix is correct - shows just the date part -->
                            <c:out value="${fn:substring(ticket.createdAt, 0, 10)}" />
                          </span>
                        </div>


                      </div>
                    </div>
                  </div>

                  <!-- Status and Actions -->
                  <div class="flex flex-col sm:flex-row items-start sm:items-center gap-3">
                    <!-- Status Badge -->
                    <c:choose>
                      <c:when test="${ticket.status == 'OPEN'}">
                        <span class="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                          <i class="fas fa-folder-open mr-1"></i>Open
                        </span>
                      </c:when>
                      <c:when test="${ticket.status == 'IN_PROGRESS'}">
                        <span class="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">
                          <i class="fas fa-cog mr-1"></i>In Progress
                        </span>
                      </c:when>
                      <c:when test="${ticket.status == 'SOLVED'}">
                        <span class="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
                          <i class="fas fa-check-circle mr-1"></i>Solved
                        </span>
                      </c:when>
                      <c:when test="${ticket.status == 'CLOSED'}">
                        <span class="inline-flex px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">
                          <i class="fas fa-times-circle mr-1"></i>Closed
                        </span>
                      </c:when>
                    </c:choose>

                    <!-- Priority Badge -->
                    <span class="inline-flex px-2 py-1 text-xs font-bold rounded
                          <c:choose>
                            <c:when test='${ticket.priority == "URGENT"}'>bg-red-100 text-red-800</c:when>
                            <c:when test='${ticket.priority == "HIGH"}'>bg-orange-100 text-orange-800</c:when>
                            <c:when test='${ticket.priority == "MEDIUM"}'>bg-yellow-100 text-yellow-800</c:when>
                            <c:otherwise>bg-green-100 text-green-800</c:otherwise>
                          </c:choose>">
                      ${ticket.priority}
                    </span>

                    <!-- Action Buttons -->
                    <div class="flex items-center gap-2">
                      <a
                        href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}"
                        class="inline-flex items-center px-3 py-1 bg-blue-100 text-blue-800 rounded-lg hover:bg-blue-200 transition-colors duration-200 text-sm"
                      >
                        <i class="fas fa-eye mr-1"></i>View
                      </a>

                      <c:if test="${ticket.status == 'OPEN'}">
                        <a
                          href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/edit"
                          class="inline-flex items-center px-3 py-1 bg-yellow-100 text-yellow-800 rounded-lg hover:bg-yellow-200 transition-colors duration-200 text-sm"
                        >
                          <i class="fas fa-edit mr-1"></i>Edit
                        </a>

                        <form
                          method="POST"
                          action="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}/delete"
                          onsubmit="return confirm('Are you sure you want to delete this ticket? This action cannot be undone.')"
                          class="inline"
                        >
                          <button
                            type="submit"
                            class="inline-flex items-center px-3 py-1 bg-red-100 text-red-800 rounded-lg hover:bg-red-200 transition-colors duration-200 text-sm"
                          >
                            <i class="fas fa-trash mr-1"></i>Delete
                          </button>
                        </form>
                      </c:if>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div class="text-center py-16">
              <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <i class="fas fa-ticket-alt text-4xl text-gray-400"></i>
              </div>
              <h3 class="text-2xl font-bold text-gray-700 mb-4">No Support Tickets</h3>
              <p class="text-gray-500 mb-8 max-w-md mx-auto">
                You haven't created any support tickets yet. Need help with your bookings or account?
              </p>
              <a
                href="${pageContext.request.contextPath}/users/support-tickets/create"
                class="inline-flex items-center bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-3 px-6 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg"
              >
                <i class="fas fa-plus mr-2"></i>Create Your First Ticket
              </a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

    </div>
  </div>

  <%@ include file="footer.jsp" %>

  <script>
    // Auto-submit search on Enter key
    document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        this.form.submit();
      }
    });
  </script>

</body>
</html>
