<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="navbar.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>All Bookings - Agency Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#1e40af',
            secondary: '#64748b'
          }
        }
      }
    }
  </script>

  <style>
    .bookings-bg {
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
  <div class="bookings-bg py-8">
    <div class="container mx-auto px-4">
      <div class="flex items-center justify-between text-white">
        <div>
          <div class="flex items-center mb-2">
            <a href="${pageContext.request.contextPath}/agency/dashboard"
               class="mr-4 p-2 hover:bg-white hover:bg-opacity-20 rounded-lg transition-colors duration-200">
              <i class="fas fa-arrow-left text-xl"></i>
            </a>
            <h1 class="text-4xl font-bold">All Bookings</h1>
          </div>
          <p class="text-white opacity-80">Manage and track all your customer bookings</p>
        </div>

        <div class="text-right">
          <div class="text-2xl font-bold">${totalBookings}</div>
          <div class="text-white opacity-80">Total Bookings</div>
        </div>
      </div>
    </div>
  </div>

  <div class="container mx-auto px-4 py-8 -mt-4">

    <!-- Quick Stats -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-green-500 to-blue-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-check-circle text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${confirmedCount}</h3>
        <p class="text-gray-600 text-sm">Confirmed Bookings</p>
      </div>

      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-yellow-500 to-orange-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-clock text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${pendingCount}</h3>
        <p class="text-gray-600 text-sm">Pending Bookings</p>
      </div>

      <div class="glass-effect rounded-2xl p-6 text-center fade-in">
        <div class="w-12 h-12 bg-gradient-to-r from-red-500 to-pink-600 rounded-full flex items-center justify-center mx-auto mb-3">
          <i class="fas fa-times-circle text-white text-lg"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900">${cancelledCount}</h3>
        <p class="text-gray-600 text-sm">Cancelled Bookings</p>
      </div>
    </div>

    <!-- Main Content -->
    <div class="glass-effect rounded-3xl shadow-2xl p-8 fade-in">

      <!-- Search and Filter Section -->
      <div class="flex flex-col lg:flex-row lg:justify-between lg:items-center mb-8 gap-6">
        <div class="flex-1">
          <h2 class="text-2xl font-bold text-gray-900 mb-2">Booking Management</h2>
          <p class="text-gray-600">Search, filter, and manage your customer bookings</p>
        </div>

        <div class="flex flex-col sm:flex-row gap-4">
          <!-- Search Input -->
          <div class="relative">
            <form method="GET" action="${pageContext.request.contextPath}/agency/bookings">
              <input type="hidden" name="status" value="${statusFilter}">
              <input type="hidden" name="page" value="1">
              <input
                type="text"
                name="search"
                value="${searchQuery}"
                placeholder="Search by customer, package..."
                class="w-full sm:w-80 pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent shadow-sm"
              />
              <i class="fas fa-search absolute left-4 top-4 text-gray-400"></i>
              <button type="submit" class="absolute right-2 top-2 px-4 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200">
                <i class="fas fa-search"></i>
              </button>
            </form>
          </div>

          <!-- Status Filter -->
          <form method="GET" action="${pageContext.request.contextPath}/agency/bookings" class="relative">
            <input type="hidden" name="search" value="${searchQuery}">
            <input type="hidden" name="page" value="1">
            <select
              name="status"
              onchange="this.form.submit()"
              class="appearance-none bg-white border border-gray-300 rounded-xl px-4 py-3 pr-10 focus:ring-2 focus:ring-blue-500 focus:border-transparent shadow-sm"
            >
              <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>All Status</option>
              <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Confirmed</option>
              <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Pending</option>
              <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Cancelled</option>
            </select>
            <i class="fas fa-chevron-down absolute right-3 top-4 text-gray-400 pointer-events-none"></i>
          </form>

          <!-- Export Button -->
          <button
            onclick="exportBookings()"
            class="flex items-center px-6 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors duration-200 shadow-sm"
          >
            <i class="fas fa-download mr-2"></i>
            Export
          </button>
        </div>
      </div>

      <!-- Bookings Table -->
      <div class="overflow-x-auto bg-white rounded-xl shadow-sm">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <div class="flex items-center">
                  <i class="fas fa-hashtag mr-2"></i>
                  Booking ID
                </div>
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <div class="flex items-center">
                  <i class="fas fa-user mr-2"></i>
                  Customer
                </div>
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <div class="flex items-center">
                  <i class="fas fa-suitcase mr-2"></i>
                  Package
                </div>
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <div class="flex items-center">
                  <i class="fas fa-calendar mr-2"></i>
                  Booking Date
                </div>
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <div class="flex items-center">
                  <i class="fas fa-users mr-2"></i>
                  Guests
                </div>
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                <div class="flex items-center">
                  <i class="fas fa-info-circle mr-2"></i>
                  Status
                </div>
              </th>
              <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <c:choose>
              <c:when test="${not empty bookings}">
                <c:forEach var="booking" items="${bookings}" varStatus="status">
                  <tr class="hover:bg-gray-50 transition-colors duration-150">
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">#${booking.id}</div>
                      <div class="text-xs text-gray-500">
                        <fmt:formatDate value="${booking.createdAtDate}" pattern="MMM dd" />
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="flex items-center">
                        <div class="flex-shrink-0 h-12 w-12">
                          <img
                            class="h-12 w-12 rounded-full border-2 border-gray-200"
                            src="https://ui-avatars.com/api/?name=${booking.user.username}&background=667eea&color=fff&size=48"
                            alt="${booking.user.username}"
                          />
                        </div>
                        <div class="ml-4">
                          <div class="text-sm font-medium text-gray-900">
                            ${booking.user.username}
                          </div>
                          <div class="text-sm text-gray-500">
                            ${booking.user.email}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <div class="text-sm font-medium text-gray-900">${booking.travelPackage.name}</div>
                      <div class="text-sm text-gray-500 flex items-center mt-1">
                        <i class="fas fa-map-marker-alt mr-1"></i>
                        ${booking.travelPackage.destination}
                      </div>
                      <div class="text-xs text-blue-600 mt-1">
                        ${booking.travelPackage.duration} days • $${booking.travelPackage.price}
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm text-gray-900">
                        <fmt:formatDate value="${booking.bookingDateAsDate}" pattern="MMM dd, yyyy" />
                      </div>
                      <div class="text-xs text-gray-500">
                        <fmt:formatDate value="${booking.bookingDateAsDate}" pattern="EEEE" />
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                      <div class="inline-flex items-center px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">
                        <i class="fas fa-users mr-1"></i>
                        ${booking.guestCount}
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <c:choose>
                        <c:when test="${booking.bookingStatus == 'CONFIRMED'}">
                          <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                            <i class="fas fa-check-circle mr-1"></i>Confirmed
                          </span>
                        </c:when>
                        <c:when test="${booking.bookingStatus == 'PENDING'}">
                          <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800">
                            <i class="fas fa-clock mr-1"></i>Pending
                          </span>
                        </c:when>
                        <c:when test="${booking.bookingStatus == 'CANCELLED'}">
                          <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                            <i class="fas fa-times-circle mr-1"></i>Cancelled
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gray-100 text-gray-800">
                            ${booking.bookingStatus}
                          </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div class="flex items-center space-x-2">
                        <button
                          onclick="viewBookingDetails(${booking.id})"
                          class="inline-flex items-center px-3 py-1 bg-blue-100 text-blue-800 rounded-lg hover:bg-blue-200 transition-colors duration-200"
                          title="View Details"
                        >
                          <i class="fas fa-eye mr-1"></i>View
                        </button>
                        <button
                          onclick="downloadInvoice(${booking.id})"
                          class="inline-flex items-center px-3 py-1 bg-gray-100 text-gray-800 rounded-lg hover:bg-gray-200 transition-colors duration-200"
                          title="Download Invoice"
                        >
                          <i class="fas fa-download mr-1"></i>PDF
                        </button>
                        <div class="relative group">
                          <button
                            class="inline-flex items-center px-2 py-1 bg-gray-100 text-gray-800 rounded-lg hover:bg-gray-200 transition-colors duration-200"
                            title="More Actions"
                          >
                            <i class="fas fa-ellipsis-v"></i>
                          </button>
                          <!-- Dropdown menu would go here -->
                        </div>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="7" class="px-6 py-16 text-center">
                    <div class="flex flex-col items-center">
                      <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                        <i class="fas fa-calendar-times text-4xl text-gray-400"></i>
                      </div>
                      <h3 class="text-lg font-medium text-gray-900 mb-1">No bookings found</h3>
                      <p class="text-gray-500 mb-4">
                        <c:choose>
                          <c:when test="${not empty searchQuery or statusFilter != 'all'}">
                            No bookings match your current search or filter criteria.
                          </c:when>
                          <c:otherwise>
                            You don't have any bookings yet. When customers book your packages, they'll appear here.
                          </c:otherwise>
                        </c:choose>
                      </p>
                      <c:if test="${not empty searchQuery or statusFilter != 'all'}">
                        <a
                          href="${pageContext.request.contextPath}/agency/bookings"
                          class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200"
                        >
                          <i class="fas fa-refresh mr-2"></i>Clear Filters
                        </a>
                      </c:if>
                    </div>
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <c:if test="${totalPages > 1}">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mt-8 gap-4">
          <div class="text-sm text-gray-700">
            Showing page ${currentPage} of ${totalPages}
            <span class="font-medium">(${totalBookings} total bookings)</span>
          </div>

          <nav class="flex items-center space-x-1">
            <!-- Previous Button -->
            <c:if test="${currentPage > 1}">
              <a
                href="${pageContext.request.contextPath}/agency/bookings?page=${currentPage - 1}&search=${searchQuery}&status=${statusFilter}"
                class="flex items-center px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-gray-700 transition-colors duration-200"
              >
                <i class="fas fa-chevron-left mr-1"></i>Previous
              </a>
            </c:if>

            <!-- Page Numbers -->
            <c:forEach begin="1" end="${totalPages}" var="pageNum">
              <c:choose>
                <c:when test="${pageNum == currentPage}">
                  <span class="flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-blue-600 rounded-lg">
                    ${pageNum}
                  </span>
                </c:when>
                <c:when test="${pageNum <= 3 or pageNum > totalPages - 3 or (pageNum >= currentPage - 1 and pageNum <= currentPage + 1)}">
                  <a
                    href="${pageContext.request.contextPath}/agency/bookings?page=${pageNum}&search=${searchQuery}&status=${statusFilter}"
                    class="flex items-center px-4 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-gray-700 transition-colors duration-200"
                  >
                    ${pageNum}
                  </a>
                </c:when>
                <c:when test="${pageNum == 4 and currentPage > 5}">
                  <span class="flex items-center px-3 py-2 text-sm font-medium text-gray-500">...</span>
                </c:when>
                <c:when test="${pageNum == totalPages - 3 and currentPage < totalPages - 4}">
                  <span class="flex items-center px-3 py-2 text-sm font-medium text-gray-500">...</span>
                </c:when>
              </c:choose>
            </c:forEach>

            <!-- Next Button -->
            <c:if test="${currentPage < totalPages}">
              <a
                href="${pageContext.request.contextPath}/agency/bookings?page=${currentPage + 1}&search=${searchQuery}&status=${statusFilter}"
                class="flex items-center px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-gray-700 transition-colors duration-200"
              >
                Next<i class="fas fa-chevron-right ml-1"></i>
              </a>
            </c:if>
          </nav>
        </div>
      </c:if>

    </div>
  </div>

  <%@ include file="footer.jsp" %>

  <script>
    function viewBookingDetails(bookingId) {
      // You can implement a modal or redirect to details page
      window.location.href = `${pageContext.request.contextPath}/agency/booking/${bookingId}`;
    }

    function downloadInvoice(bookingId) {
      // Implement invoice download functionality
      alert(`Downloading invoice for booking #${bookingId}`);
      // Example: window.open(`/agency/booking/${bookingId}/invoice`, '_blank');
    }

    function exportBookings() {
      // Implement export functionality
      const searchQuery = '${searchQuery}';
      const statusFilter = '${statusFilter}';
      alert(`Exporting bookings with search: "${searchQuery}" and status: "${statusFilter}"`);
      // Example: window.open(`/agency/bookings/export?search=${searchQuery}&status=${statusFilter}`, '_blank');
    }

    // Auto-submit search on Enter key
    document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        this.form.submit();
      }
    });
  </script>

</body>
</html>
