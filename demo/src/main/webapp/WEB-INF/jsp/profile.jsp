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
  <title>User Profile - TourMate</title>
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
    .profile-bg {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .glass-effect {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .floating-animation {
      animation: float 6s ease-in-out infinite;
    }

    @keyframes float {
      0%, 100% { transform: translateY(0px); }
      50% { transform: translateY(-10px); }
    }

    .fade-in {
      animation: fadeIn 0.8s ease-out;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .profile-card {
      transition: all 0.3s ease;
    }

    .profile-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    .avatar-glow {
      box-shadow: 0 0 30px rgba(102, 126, 234, 0.3);
    }

    .input-field:focus {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    }
  </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">



  <!-- Background Section -->
  <div class="profile-bg py-12">
    <div class="container mx-auto px-4 py-8 flex-1">

      <!-- Page Header -->
      <div class="text-center mb-12 fade-in">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-white bg-opacity-20 rounded-full mb-4 floating-animation">
          <i class="fas fa-user text-2xl text-white"></i>
        </div>
        <h1 class="text-4xl font-bold text-white mb-2">User Profile</h1>
        <p class="text-white opacity-80">Manage your personal information and settings</p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">

        <!-- Left Panel: Avatar, Name, Email, Delete -->
        <div class="lg:col-span-1 profile-card glass-effect rounded-3xl shadow-2xl p-8 flex flex-col items-center fade-in">

          <!-- Avatar Section -->
          <div class="relative mb-6">
            <img
              src="https://static.vecteezy.com/system/resources/previews/009/734/564/non_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg"
              alt="User Avatar"
              class="w-32 h-32 rounded-full object-cover avatar-glow border-4 border-white shadow-lg"
            />
            <div class="absolute -bottom-2 -right-2 w-10 h-10 bg-green-500 rounded-full border-4 border-white flex items-center justify-center">
              <i class="fas fa-check text-white text-sm"></i>
            </div>
          </div>

          <!-- User Info -->
          <div class="text-center mb-6">
            <h2 class="text-2xl font-bold text-gray-900 mb-2">
              <c:out value="${user != null ? user.username : 'Guest'}" />
            </h2>
            <div class="w-16 h-1 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full mx-auto mb-4"></div>
            <div class="bg-gray-50 rounded-xl p-3 mb-4">
              <p class="text-gray-700 font-medium flex items-center justify-center">
                <i class="fas fa-envelope text-blue-500 mr-2"></i>
                <c:out value="${user != null ? user.email : 'N/A'}" />
              </p>
            </div>
          </div>

          <!-- User Stats Cards -->
          <div class="grid grid-cols-2 gap-3 w-full mb-6">
            <div class="bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl p-4 text-center text-white">
              <i class="fas fa-calendar-alt text-lg mb-2"></i>
              <div class="text-sm opacity-90">Member Since</div>
              <div class="font-bold">2024</div>
            </div>
            <div class="bg-gradient-to-r from-green-500 to-blue-600 rounded-xl p-4 text-center text-white">
              <i class="fas fa-map-marked-alt text-lg mb-2"></i>
              <div class="text-sm opacity-90">Bookings Made</div>
              <div class="font-bold">
                <c:out value="${bookedPackages != null ? bookedPackages.size() : '0'}" />
              </div>
            </div>
          </div>

          <!-- Delete Profile Form -->
          <form action="${pageContext.request.contextPath}/users/delete" method="post" onsubmit="return confirm('Are you sure you want to delete your profile?');" class="w-full">
            <button
              type="submit"
              class="w-full bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white font-bold py-3 px-6 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
            >
              <i class="fas fa-trash-alt mr-2"></i>
              Delete Profile
            </button>
          </form>
        </div>

        <!-- Right Panel: Profile Details -->
        <div class="lg:col-span-2 profile-card glass-effect rounded-3xl shadow-2xl p-8 flex flex-col justify-between fade-in">

          <!-- Profile Details Header -->
          <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-12 h-12 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full mb-4">
              <i class="fas fa-id-card text-white text-lg"></i>
            </div>
            <h2 class="text-3xl font-bold text-gray-900 mb-2">
              Profile of <c:out value="${user != null ? user.username : 'Guest'}" />
            </h2>
            <p class="text-gray-600">Your personal information and details</p>
          </div>

          <!-- Profile Information Grid -->
          <div class="max-w-2xl mx-auto w-full">
            <div class="space-y-6">

              <!-- Email Field -->
              <div class="bg-gray-50 rounded-2xl p-6 hover:bg-gray-100 transition-colors duration-300">
                <div class="flex items-center">
                  <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mr-4">
                    <i class="fas fa-envelope text-blue-600 text-lg"></i>
                  </div>
                  <div class="flex-1">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                    <input
                      type="text"
                      value="<c:out value='${user != null ? user.email : \"N/A\"}' />"
                      readonly
                      class="w-full bg-white border-2 border-gray-200 text-gray-700 rounded-xl px-4 py-3 input-field transition-all duration-300 focus:outline-none focus:border-blue-500"
                    />
                  </div>
                </div>
              </div>

              <!-- Age Field -->
              <c:if test="${user != null && user.age != null}">
              <div class="bg-gray-50 rounded-2xl p-6 hover:bg-gray-100 transition-colors duration-300">
                <div class="flex items-center">
                  <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center mr-4">
                    <i class="fas fa-birthday-cake text-green-600 text-lg"></i>
                  </div>
                  <div class="flex-1">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Age</label>
                    <input
                      type="text"
                      value="${user.age}"
                      readonly
                      class="w-full bg-white border-2 border-gray-200 text-gray-700 rounded-xl px-4 py-3 input-field transition-all duration-300 focus:outline-none focus:border-green-500"
                    />
                  </div>
                </div>
              </div>
              </c:if>

              <!-- Gender Field -->
              <c:if test="${user != null && user.gender != null}">
              <div class="bg-gray-50 rounded-2xl p-6 hover:bg-gray-100 transition-colors duration-300">
                <div class="flex items-center">
                  <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center mr-4">
                    <i class="fas fa-venus-mars text-purple-600 text-lg"></i>
                  </div>
                  <div class="flex-1">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Gender</label>
                    <input
                      type="text"
                      value="${user.gender}"
                      readonly
                      class="w-full bg-white border-2 border-gray-200 text-gray-700 rounded-xl px-4 py-3 input-field transition-all duration-300 focus:outline-none focus:border-purple-500"
                    />
                  </div>
                </div>
              </div>
              </c:if>

            </div>
          </div>

          <!-- Divider with Icon -->
          <div class="flex items-center my-8">
            <div class="flex-1 border-t-2 border-gray-200"></div>
            <div class="px-4">
              <div class="w-8 h-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full flex items-center justify-center">
                <i class="fas fa-star text-white text-sm"></i>
              </div>
            </div>
            <div class="flex-1 border-t-2 border-gray-200"></div>
          </div>

          <!-- Action Buttons Section -->
          <div class="text-center">
            <div class="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
              <!-- Update Profile Button -->
              <a
                href="${pageContext.request.contextPath}/users/update"
                class="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-4 px-8 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl flex items-center justify-center"
              >
                <i class="fas fa-edit mr-2"></i>
                Update Profile
              </a>

              <!-- Settings Button -->
              <a
                href="${pageContext.request.contextPath}/users/settings"
                class="flex-1 bg-white border-2 border-gray-300 hover:border-blue-500 text-gray-700 hover:text-blue-600 font-bold py-4 px-8 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl flex items-center justify-center"
              >
                <i class="fas fa-cog mr-2"></i>
                Settings
              </a>
            </div>

            <!-- Additional Info -->
            <div class="mt-6 p-4 bg-blue-50 rounded-xl border-l-4 border-blue-500">
              <p class="text-sm text-blue-800 flex items-center justify-center">
                <i class="fas fa-info-circle mr-2"></i>
                Your profile information is secure and private
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Stats Section -->
      <div class="max-w-6xl mx-auto mt-12">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">

          <div class="glass-effect rounded-2xl p-6 text-center fade-in hover:scale-105 transition-transform duration-300">
            <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center mx-auto mb-3">
              <i class="fas fa-user-check text-white"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Verified</h3>
            <p class="text-gray-600 text-sm">Account Status</p>
          </div>

          <div class="glass-effect rounded-2xl p-6 text-center fade-in hover:scale-105 transition-transform duration-300">
            <div class="w-12 h-12 bg-gradient-to-r from-green-500 to-blue-600 rounded-full flex items-center justify-center mx-auto mb-3">
              <i class="fas fa-shield-alt text-white"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Secure</h3>
            <p class="text-gray-600 text-sm">Data Protection</p>
          </div>

          <div class="glass-effect rounded-2xl p-6 text-center fade-in hover:scale-105 transition-transform duration-300">
            <div class="w-12 h-12 bg-gradient-to-r from-orange-500 to-red-600 rounded-full flex items-center justify-center mx-auto mb-3">
              <i class="fas fa-bell text-white"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Active</h3>
            <p class="text-gray-600 text-sm">Notifications</p>
          </div>

          <div class="glass-effect rounded-2xl p-6 text-center fade-in hover:scale-105 transition-transform duration-300">
            <div class="w-12 h-12 bg-gradient-to-r from-purple-500 to-pink-600 rounded-full flex items-center justify-center mx-auto mb-3">
              <i class="fas fa-heart text-white"></i>
            </div>
            <h3 class="text-lg font-bold text-gray-900">Premium</h3>
            <p class="text-gray-600 text-sm">Member Level</p>
          </div>

        </div>
      </div>

      <!-- Booked Packages Section -->
      <div class="max-w-6xl mx-auto mt-12">
        <div class="glass-effect rounded-3xl shadow-2xl p-8 fade-in">
          <!-- Section Header -->
          <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-12 h-12 bg-gradient-to-r from-green-500 to-blue-600 rounded-full mb-4">
              <i class="fas fa-suitcase-rolling text-white text-lg"></i>
            </div>
            <h2 class="text-3xl font-bold text-gray-900 mb-2">My Booked Packages</h2>
            <p class="text-gray-600">Your travel bookings and payment history</p>
          </div>

          <c:choose>
            <c:when test="${not empty bookedPackages}">
              <!-- Packages Grid -->
              <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="payment" items="${bookedPackages}">
                    <div class="bg-white rounded-2xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 border border-gray-100">
                        <!-- Payment Header -->
                        <div class="flex justify-between items-start mb-4">
                            <div class="flex items-center">
                                <div class="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center mr-3">
                                    <i class="fas fa-plane text-white text-sm"></i>
                                </div>
                                <div>
                                    <h3 class="font-bold text-gray-900">Package #${payment.packageId}</h3>
                                    <p class="text-xs text-gray-500">${payment.transactionId}</p>
                                </div>
                            </div>
                            <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-bold uppercase">
                                ${payment.status}
                            </span>
                        </div>

                        <!-- Payment Details -->
                        <div class="space-y-3">
                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl">
                                <div class="flex items-center">
                                    <i class="fas fa-money-bill-wave text-green-500 mr-2"></i>
                                    <span class="text-sm text-gray-700">Amount Paid</span>
                                </div>
                                <span class="font-bold text-green-600">$${payment.amount}</span>
                            </div>

                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl">
                                <div class="flex items-center">
                                    <i class="fas fa-calendar-alt text-blue-500 mr-2"></i>
                                    <span class="text-sm text-gray-700">Payment Date</span>
                                </div>
                                <span class="font-medium text-gray-700">
                                    <fmt:formatDate value="${payment.createdAtDate}" pattern="MMM dd, yyyy" />
                                </span>
                            </div>

                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl">
                                <div class="flex items-center">
                                    <i class="fas fa-credit-card text-purple-500 mr-2"></i>
                                    <span class="text-sm text-gray-700">Payment Method</span>
                                </div>
                                <span class="font-medium text-gray-700">
                                  <c:out value="${payment.paymentMethod != null ? payment.paymentMethod : 'CARD'}" />
                                </span>
                            </div>

                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl">
                                <div class="flex items-center">
                                    <i class="fas fa-user text-orange-500 mr-2"></i>
                                    <span class="text-sm text-gray-700">Card Holder</span>
                                </div>
                                <span class="font-medium text-gray-700">${payment.cardHolderName}</span>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="mt-6 flex gap-2">
                            <a href="${pageContext.request.contextPath}/users/profile/download-pdf" target="_blank"
                               class="flex items-center justify-center gap-2 flex-1 bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 text-white font-semibold py-3 px-5 rounded-xl transition-transform duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl">
                                <i class="fas fa-file-pdf text-lg"></i>
                                Download Purchase Details PDF
                            </a>


                        </div>
                    </div>
                </c:forEach>

              </div>

              <!-- Summary Stats -->
              <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl p-6 text-center text-white">
                  <i class="fas fa-shopping-cart text-2xl mb-3"></i>
                  <div class="text-2xl font-bold">${bookedPackages.size()}</div>
                  <div class="text-sm opacity-90">Total Bookings</div>
                </div>
                <div class="bg-gradient-to-r from-green-500 to-blue-600 rounded-2xl p-6 text-center text-white">
                  <i class="fas fa-check-circle text-2xl mb-3"></i>
                  <div class="text-2xl font-bold">${bookedPackages.size()}</div>
                  <div class="text-sm opacity-90">Successful Payments</div>
                </div>
                <div class="bg-gradient-to-r from-orange-500 to-red-600 rounded-2xl p-6 text-center text-white">
                  <i class="fas fa-star text-2xl mb-3"></i>
                  <div class="text-2xl font-bold">⭐⭐⭐⭐⭐</div>
                  <div class="text-sm opacity-90">Your Rating</div>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <!-- Empty State -->
              <div class="text-center py-16">
                <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                  <i class="fas fa-suitcase text-4xl text-gray-400"></i>
                </div>
                <h3 class="text-2xl font-bold text-gray-700 mb-4">No Bookings Yet</h3>
                <p class="text-gray-500 mb-8 max-w-md mx-auto">
                  You haven't booked any travel packages yet. Start exploring our amazing destinations and create unforgettable memories!
                </p>
                <a href="${pageContext.request.contextPath}/packages"
                   class="inline-flex items-center bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-4 px-8 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg">
                  <i class="fas fa-compass mr-2"></i>
                  Browse Travel Packages
                </a>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <!-- Support Tickets Section - ENHANCED VERSION -->
      <div class="max-w-6xl mx-auto mt-12">
        <div class="glass-effect rounded-3xl shadow-2xl p-8 fade-in">
          <!-- Section Header -->
          <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-12 h-12 bg-gradient-to-r from-orange-500 to-red-600 rounded-full mb-4">
              <i class="fas fa-headset text-white text-lg"></i>
            </div>
            <h2 class="text-3xl font-bold text-gray-900 mb-2">My Support Tickets</h2>
            <p class="text-gray-600">Track your support requests and get help</p>
          </div>

          <!-- Quick Actions -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center mb-8">
            <a
              href="${pageContext.request.contextPath}/users/support-tickets/create"
              class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg"
            >
              <i class="fas fa-plus mr-2"></i>Create New Ticket
            </a>
            <a
              href="${pageContext.request.contextPath}/users/support-tickets"
              class="inline-flex items-center px-6 py-3 bg-white border-2 border-gray-300 hover:border-blue-500 text-gray-700 hover:text-blue-600 font-bold rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg"
            >
              <i class="fas fa-list mr-2"></i>View All Tickets
            </a>
          </div>

          <!-- Display User Tickets -->
          <c:choose>
            <c:when test="${not empty userTickets}">
              <!-- Tickets Count Header -->
              <div class="flex justify-between items-center mb-6">
                <h3 class="text-xl font-bold text-gray-900">Your Recent Support Requests</h3>
                <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">
                  ${userTickets.size()} Recent Ticket<c:if test="${userTickets.size() != 1}">s</c:if>
                </span>
              </div>

              <!-- Tickets Grid -->
              <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                <c:forEach var="ticket" items="${userTickets}">
                  <div class="bg-white border border-gray-200 rounded-xl p-6 hover:shadow-md transition-all duration-200 transform hover:scale-105">
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
                          <i class="fas fa-exclamation-triangle text-lg"></i>
                        </div>
                      </div>

                      <!-- Ticket Info -->
                      <div class="flex-1 min-w-0">
                        <div class="flex items-center justify-between mb-2">
                          <h4 class="font-bold text-gray-900 truncate">
                            <a href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}"
                               class="hover:text-blue-600 transition-colors duration-200">
                              ${ticket.subject}
                            </a>
                          </h4>
                          <!-- Status Badge -->
                          <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full ml-2
                                <c:choose>
                                  <c:when test='${ticket.status == "OPEN"}'>bg-blue-100 text-blue-800</c:when>
                                  <c:when test='${ticket.status == "IN_PROGRESS"}'>bg-yellow-100 text-yellow-800</c:when>
                                  <c:when test='${ticket.status == "SOLVED"}'>bg-green-100 text-green-800</c:when>
                                  <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                </c:choose>">
                            ${ticket.status}
                          </span>
                        </div>

                        <p class="text-gray-600 text-sm mb-3 line-clamp-2">
                          ${ticket.description}
                        </p>

                        <!-- Ticket Meta -->
                        <div class="flex items-center justify-between text-xs text-gray-500">
                          <div class="flex items-center gap-3">
                            <span class="flex items-center">
                              <i class="fas fa-hashtag mr-1"></i>#${ticket.id}
                            </span>
                            <span class="flex items-center">
                              <i class="fas fa-clock mr-1"></i>
                              <c:out value="${fn:substring(ticket.createdAt, 0, 10)}" />
                            </span>
                          </div>
                          <span class="px-2 py-1 rounded font-medium
                                <c:choose>
                                  <c:when test='${ticket.priority == "URGENT"}'>bg-red-50 text-red-700</c:when>
                                  <c:when test='${ticket.priority == "HIGH"}'>bg-orange-50 text-orange-700</c:when>
                                  <c:when test='${ticket.priority == "MEDIUM"}'>bg-yellow-50 text-yellow-700</c:when>
                                  <c:otherwise>bg-green-50 text-green-700</c:otherwise>
                                </c:choose>">
                            ${ticket.priority}
                          </span>
                        </div>

                        <!-- Action Button -->
                        <div class="mt-4">
                          <a
                            href="${pageContext.request.contextPath}/users/support-tickets/${ticket.id}"
                            class="w-full inline-flex items-center justify-center px-4 py-2 bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white text-sm font-medium rounded-lg transition-all duration-300"
                          >
                            <i class="fas fa-eye mr-2"></i>View Details
                          </a>
                        </div>

                        <!-- Show reply status if exists -->
                        <c:if test="${not empty ticket.agencyReply || not empty ticket.adminReply}">
                          <div class="mt-3 p-2 bg-green-50 rounded-lg border-l-4 border-green-500">
                            <div class="flex items-center">
                              <i class="fas fa-reply text-green-600 mr-2"></i>
                              <span class="text-green-800 text-xs font-medium">Support team replied</span>
                            </div>
                          </div>
                        </c:if>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <!-- View All Link -->
              <div class="text-center">
                <a
                  href="${pageContext.request.contextPath}/users/support-tickets"
                  class="inline-flex items-center px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-700 hover:text-gray-900 font-medium rounded-xl transition-all duration-300"
                >
                  <i class="fas fa-arrow-right mr-2"></i>
                  View All Your Support Tickets
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <!-- Empty State -->
              <div class="text-center py-12">
                <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                  <i class="fas fa-headset text-3xl text-gray-400"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-700 mb-2">No Support Tickets</h3>
                <p class="text-gray-500 mb-6 max-w-sm mx-auto">
                  You haven't created any support tickets yet. Need help with your bookings?
                </p>
                <a
                  href="${pageContext.request.contextPath}/users/support-tickets/create"
                  class="inline-flex items-center bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-3 px-6 rounded-xl transition-all duration-300 transform hover:scale-105 shadow-lg"
                >
                  <i class="fas fa-plus mr-2"></i>Get Support
                </a>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>



    </div>
  </div>

  <%@ include file="footer.jsp" %>

  <script>
    // Add fade-in animation on scroll
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('fade-in');
        }
      });
    }, observerOptions);

    // Observe all cards
    document.addEventListener('DOMContentLoaded', function() {
      const cards = document.querySelectorAll('.profile-card, .fade-in');
      cards.forEach(card => {
        observer.observe(card);
      });
    });
  </script>
</body>
</html>
