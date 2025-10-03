<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Navbar -->
<nav class="bg-gradient-to-r from-primary to-blue-600 text-white shadow-lg">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between h-16">
      <!-- Logo -->
      <div class="flex-shrink-0">
        <a href="${pageContext.request.contextPath}/" class="text-2xl font-bold text-white hover:text-yellow-400 transition-colors duration-300">
          TourMate
        </a>
      </div>

      <!-- Desktop Menu -->
      <div class="hidden md:flex md:items-center space-x-6">
        <a href="${pageContext.request.contextPath}/" class="hover:text-yellow-400 transition-colors duration-300">Home</a>
        <a href="${pageContext.request.contextPath}/about-us" class="hover:text-yellow-400 transition-colors duration-300">About Us</a>

        <!-- Show common links for non-logged-in users and regular users -->
        <c:if test="${empty sessionScope.loggedInUser or sessionScope.userRole == 'USER'}">
          <a href="${pageContext.request.contextPath}/destinations" class="hover:text-yellow-400 transition-colors duration-300">Destinations</a>
          <a href="${pageContext.request.contextPath}/tours" class="hover:text-yellow-400 transition-colors duration-300">Tours</a>
        </c:if>

        <!-- Support Ticket Link - Show for all logged-in users -->
        <c:if test="${not empty sessionScope.loggedInUser}">
          <a href="${pageContext.request.contextPath}/users/support-tickets" class="flex items-center hover:text-yellow-400 transition-colors duration-300">
            <i class="fas fa-headset mr-2"></i>Support
          </a>
        </c:if>

        <!-- Show when user is logged in -->
        <c:if test="${not empty sessionScope.loggedInUser}">

          <!-- Admin-specific links -->
          <c:if test="${sessionScope.userRole == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 px-4 py-2 rounded-full text-black font-semibold transition-all duration-300 transform hover:scale-105">
              Admin Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="hover:text-yellow-400 transition-colors duration-300">Manage Users</a>
          </c:if>

          <!-- Agency-specific links -->
          <c:if test="${sessionScope.userRole == 'AGENCY'}">
            <a href="${pageContext.request.contextPath}/agency/dashboard" class="bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 px-4 py-2 rounded-full text-white font-semibold transition-all duration-300 transform hover:scale-105">
              Agency Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/agency/packages" class="hover:text-yellow-400 transition-colors duration-300">My Packages</a>
          </c:if>

          <!-- Regular user links -->
          <c:if test="${sessionScope.userRole == 'USER'}">
            <!-- Profile icon -->
            <div id="profileIcon" class="flex items-center space-x-2">
              <a href="${pageContext.request.contextPath}/users/profile" class="flex items-center justify-center w-10 h-10 rounded-full bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 transition-all duration-300 transform hover:scale-110 shadow-lg">
                <img src="https://th.bing.com/th/id/OIP.e3qvNUpZQb8-Hc0vyTIIogAAAA?w=425&h=425&rs=1&pid=ImgDetMain"
                     alt="Profile" class="w-full h-full object-cover rounded-full">
              </a>
            </div>
            <a href="${pageContext.request.contextPath}/packages" class="bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 px-4 py-2 rounded-full text-black font-semibold transition-all duration-300 transform hover:scale-105">
              Book Now
            </a>
          </c:if>

          <a href="${pageContext.request.contextPath}/users/logout" class="bg-red-500 hover:bg-red-600 px-4 py-2 rounded-full text-white font-semibold transition-all duration-300 transform hover:scale-105">
            Logout
          </a>
        </c:if>

        <!-- Show when not logged in -->
        <c:if test="${empty sessionScope.loggedInUser}">
          <a href="${pageContext.request.contextPath}/contact" class="flex items-center hover:text-yellow-400 transition-colors duration-300">
            <i class="fas fa-envelope mr-2"></i>Contact
          </a>

          <a href="${pageContext.request.contextPath}/users/login" class="bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 px-4 py-2 rounded-full text-black font-semibold transition-all duration-300 transform hover:scale-105">
            Login
          </a>
          <a href="${pageContext.request.contextPath}/users/register" class="bg-white bg-opacity-20 backdrop-blur-sm hover:bg-opacity-30 px-4 py-2 rounded-full text-white font-semibold transition-all duration-300 border border-white border-opacity-30">
            Register
          </a>
          <a href="${pageContext.request.contextPath}/packages" class="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 px-4 py-2 rounded-full text-white font-semibold transition-all duration-300 transform hover:scale-105">
            Book Now
          </a>
        </c:if>
      </div>

      <!-- Mobile Menu Button -->
      <div class="flex md:hidden">
        <button id="navbar-toggler" class="text-yellow-400 hover:text-yellow-300 focus:outline-none transition-colors duration-300">
          <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
      </div>
    </div>
  </div>

  <!-- Mobile Menu -->
  <div id="mobile-menu" class="hidden md:hidden bg-gradient-to-r from-blue-700 to-purple-700 px-4 pt-4 pb-3 space-y-3">
    <a href="${pageContext.request.contextPath}/" class="block hover:text-yellow-400 transition-colors duration-300 py-2">Home</a>
    <a href="${pageContext.request.contextPath}/about-us" class="block hover:text-yellow-400 transition-colors duration-300 py-2">About Us</a>

    <!-- Show common links for non-logged-in users and regular users -->
    <c:if test="${empty sessionScope.loggedInUser or sessionScope.userRole == 'USER'}">
      <a href="${pageContext.request.contextPath}/destinations" class="block hover:text-yellow-400 transition-colors duration-300 py-2">Destinations</a>
      <a href="${pageContext.request.contextPath}/tours" class="block hover:text-yellow-400 transition-colors duration-300 py-2">Tours</a>
    </c:if>

    <!-- Support Ticket Link - Mobile version for all logged-in users -->
    <c:if test="${not empty sessionScope.loggedInUser}">
      <a href="${pageContext.request.contextPath}/users/support-tickets" class="block hover:text-yellow-400 transition-colors duration-300 py-2">
        <i class="fas fa-headset mr-2"></i>Support Tickets
      </a>
    </c:if>

    <!-- Show when user is logged in -->
    <c:if test="${not empty sessionScope.loggedInUser}">

      <!-- Admin-specific mobile links -->
      <c:if test="${sessionScope.userRole == 'ADMIN'}">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="block bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 px-4 py-2 rounded-full text-black font-semibold mb-2 text-center">
          Admin Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="block hover:text-yellow-400 transition-colors duration-300 py-2">Manage Users</a>
      </c:if>

      <!-- Agency-specific mobile links -->
      <c:if test="${sessionScope.userRole == 'AGENCY'}">
        <a href="${pageContext.request.contextPath}/agency/dashboard" class="block bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 px-4 py-2 rounded-full text-white font-semibold mb-2 text-center">
          Agency Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/agency/packages" class="block hover:text-yellow-400 transition-colors duration-300 py-2">My Packages</a>
      </c:if>

      <!-- Regular user mobile links -->
      <c:if test="${sessionScope.userRole == 'USER'}">
        <!-- Mobile Profile icon -->
        <div id="profileIconMobile" class="flex items-center space-x-2 py-2">
          <a href="${pageContext.request.contextPath}/users/profile" class="flex items-center justify-center w-10 h-10 rounded-full bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 transition-all duration-300">
            <img src="https://th.bing.com/th/id/OIP.e3qvNUpZQb8-Hc0vyTIIogAAAA?w=425&h=425&rs=1&pid=ImgDetMain"
                 alt="Profile" class="w-full h-full object-cover rounded-full">
          </a>
          <span class="text-white">Profile</span>
        </div>
        <a href="${pageContext.request.contextPath}/packages" class="block bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 px-4 py-2 rounded-full text-black font-semibold text-center">
          Book Now
        </a>
      </c:if>

      <a href="${pageContext.request.contextPath}/users/logout" class="block bg-red-500 hover:bg-red-600 px-4 py-2 rounded-full text-white font-semibold text-center">
        Logout
      </a>
    </c:if>

    <!-- Show when not logged in -->
    <c:if test="${empty sessionScope.loggedInUser}">
      <a href="${pageContext.request.contextPath}/contact" class="block hover:text-yellow-400 transition-colors duration-300 py-2">
        <i class="fas fa-envelope mr-2"></i>Contact Support
      </a>

      <a href="${pageContext.request.contextPath}/users/login" class="block bg-gradient-to-r from-yellow-400 to-orange-500 hover:from-yellow-500 hover:to-orange-600 px-4 py-2 rounded-full text-black font-semibold text-center mb-2">
        Login
      </a>
      <a href="${pageContext.request.contextPath}/users/register" class="block bg-white bg-opacity-20 backdrop-blur-sm hover:bg-opacity-30 px-4 py-2 rounded-full text-white font-semibold border border-white border-opacity-30 text-center mb-2">
        Register
      </a>
      <a href="${pageContext.request.contextPath}/packages" class="block bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 px-4 py-2 rounded-full text-white font-semibold text-center">
        Book Now
      </a>
    </c:if>
  </div>
</nav>

<script>
  // Mobile menu toggler
  const toggler = document.getElementById('navbar-toggler');
  const mobileMenu = document.getElementById('mobile-menu');
  if (toggler && mobileMenu) {
    toggler.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }
</script>

<style>
  /* Add primary color definition for consistency */
  :root {
    --primary: #1e40af;
  }

  .from-primary {
    --tw-gradient-from: var(--primary);
  }

  .to-primary {
    --tw-gradient-to: var(--primary);
  }
</style>
