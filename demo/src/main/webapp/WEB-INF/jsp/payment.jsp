<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="navbar.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - TourMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* Loading Animation */
        .payment-loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 9999;
        }

        .loading-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: white;
        }

        .spinner {
            width: 60px;
            height: 60px;
            border: 6px solid #f3f3f3;
            border-top: 6px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Success Animation */
        .payment-success {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            z-index: 10000;
        }

        .success-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: white;
            animation: successFadeIn 0.8s ease-out;
        }

        @keyframes successFadeIn {
            from {
                opacity: 0;
                transform: translate(-50%, -60%);
            }
            to {
                opacity: 1;
                transform: translate(-50%, -50%);
            }
        }

        .success-checkmark {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #4CAF50;
            margin: 0 auto 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: successPulse 1.5s ease-in-out;
            box-shadow: 0 0 30px rgba(76, 175, 80, 0.4);
        }

        @keyframes successPulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
        }

        .checkmark {
            font-size: 60px;
            color: white;
            animation: checkmarkDraw 0.8s ease-in-out 0.3s both;
        }

        @keyframes checkmarkDraw {
            0% {
                opacity: 0;
                transform: scale(0);
            }
            50% {
                opacity: 1;
                transform: scale(1.2);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        .success-text {
            animation: textSlideUp 0.8s ease-out 0.6s both;
        }

        @keyframes textSlideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #f39c12;
            animation: confettiFall 3s linear infinite;
        }

        .confetti:nth-child(odd) {
            background: #e74c3c;
            animation-delay: 0.5s;
        }

        .confetti:nth-child(3n) {
            background: #9b59b6;
            animation-delay: 1s;
        }

        .confetti:nth-child(4n) {
            background: #3498db;
            animation-delay: 1.5s;
        }

        @keyframes confettiFall {
            0% {
                opacity: 1;
                transform: translateY(-100vh) rotate(0deg);
            }
            100% {
                opacity: 0;
                transform: translateY(100vh) rotate(360deg);
            }
        }

        /* Payment processing states */
        .payment-form.processing {
            pointer-events: none;
            opacity: 0.7;
        }
    </style>
</head>
<body class="bg-gray-100">

<!-- Payment Loading Overlay -->
<div id="paymentLoading" class="payment-loading">
    <div class="loading-content">
        <div class="spinner"></div>
        <h3 class="text-xl font-semibold mb-2">Processing Payment...</h3>
        <p class="text-gray-300">Please wait while we securely process your payment</p>
    </div>
</div>

<!-- Payment Success Overlay -->
<div id="paymentSuccess" class="payment-success">
    <!-- Confetti Animation -->
    <div class="confetti" style="left: 10%; animation-delay: 0s;"></div>
    <div class="confetti" style="left: 20%; animation-delay: 0.2s;"></div>
    <div class="confetti" style="left: 30%; animation-delay: 0.4s;"></div>
    <div class="confetti" style="left: 40%; animation-delay: 0.6s;"></div>
    <div class="confetti" style="left: 50%; animation-delay: 0.8s;"></div>
    <div class="confetti" style="left: 60%; animation-delay: 1s;"></div>
    <div class="confetti" style="left: 70%; animation-delay: 1.2s;"></div>
    <div class="confetti" style="left: 80%; animation-delay: 1.4s;"></div>
    <div class="confetti" style="left: 90%; animation-delay: 1.6s;"></div>

    <div class="success-content">
        <div class="success-checkmark">
            <i class="fas fa-check checkmark"></i>
        </div>

        <div class="success-text">
            <h1 class="text-4xl font-bold mb-4">Payment Successful!</h1>
            <p class="text-xl mb-6">Your booking has been confirmed successfully</p>
            <div class="flex items-center justify-center text-lg">
                <i class="fas fa-suitcase-rolling mr-2"></i>
                <span>Redirecting to your profile...</span>
            </div>
        </div>
    </div>
</div>

<div class="container mx-auto px-4 py-8">
    <div class="max-w-4xl mx-auto">

        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-800 mb-2">Complete Your Booking</h1>
            <p class="text-gray-600">Secure payment for your travel package</p>
        </div>

        <div class="grid md:grid-cols-2 gap-8">

            <!-- Package Summary -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h2 class="text-2xl font-bold mb-4">Booking Summary</h2>

                <div class="space-y-4">
                    <div class="border-b pb-4">
                        <h3 class="text-lg font-semibold">${pkg.name}</h3>
                        <p class="text-gray-600">${pkg.destination}</p>
                    </div>

                    <div class="flex justify-between">
                        <span>Duration:</span>
                        <span>${pkg.duration} days</span>
                    </div>

                    <div class="flex justify-between">
                        <span>Package Price:</span>
                        <span class="font-semibold">${pkg.currency}${pkg.price}</span>
                    </div>

                    <div class="border-t pt-4 flex justify-between text-xl font-bold">
                        <span>Total Amount:</span>
                        <span class="text-green-600">${pkg.currency}${pkg.price}</span>
                    </div>
                </div>
            </div>

            <!-- Payment Form -->
            <div class="bg-white rounded-xl shadow-lg p-6 payment-form" id="paymentFormContainer">
                <h2 class="text-2xl font-bold mb-4">Payment Details</h2>

                <form action="${pageContext.request.contextPath}/payment/process" method="post" id="paymentForm">
                    <input type="hidden" name="packageId" value="${pkg.id}">

                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Card Holder Name</label>
                            <input type="text" name="cardHolderName" required
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   placeholder="John Doe">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Card Number</label>
                            <input type="text" name="cardNumber" required maxlength="19"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                   placeholder="1234 5678 9012 3456" id="cardNumber">
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Expiry Date</label>
                                <input type="text" name="cardExpiry" required maxlength="5"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                       placeholder="MM/YY" id="cardExpiry">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">CVV</label>
                                <input type="password" name="cardCvv" required maxlength="4"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                       placeholder="123">
                            </div>
                        </div>

                        <div class="pt-4">
                            <button type="submit" id="payButton"
                                    class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-4 rounded-lg transition-all duration-300">
                                <i class="fas fa-lock mr-2"></i>Pay Securely - ${pkg.currency}${pkg.price}
                            </button>
                        </div>
                    </div>
                </form>

                <div class="mt-4 text-center text-sm text-gray-500">
                    <i class="fas fa-shield-alt mr-1"></i>Your payment information is secure and encrypted
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Format card number input
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
        let formattedInputValue = value.match(/.{1,4}/g)?.join(' ') || '';
        e.target.value = formattedInputValue.substring(0, 19);
    });

    // Format expiry date input
    document.getElementById('cardExpiry').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length >= 2) {
            value = value.substring(0, 2) + '/' + value.substring(2, 4);
        }
        e.target.value = value;
    });

    // Payment form submission with animation
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent default form submission

        // Show loading animation
        document.getElementById('paymentLoading').style.display = 'block';
        document.getElementById('paymentFormContainer').classList.add('processing');

        // Simulate processing time (1.5 seconds)
        setTimeout(() => {
            // Hide loading, show success
            document.getElementById('paymentLoading').style.display = 'none';
            document.getElementById('paymentSuccess').style.display = 'block';

            // After showing success for 4 seconds, submit the form
            setTimeout(() => {
                // Actually submit the form
                const form = document.getElementById('paymentForm');
                const formData = new FormData(form);

                // Submit via JavaScript to handle the redirect
                fetch(form.action, {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    if (response.ok) {
                        // Redirect to profile page
                        window.location.href = '${pageContext.request.contextPath}/users/profile';
                    } else {
                        // Handle error - hide success and show error message
                        document.getElementById('paymentSuccess').style.display = 'none';
                        alert('Payment failed. Please try again.');
                        document.getElementById('paymentFormContainer').classList.remove('processing');
                    }
                }).catch(error => {
                    console.error('Payment error:', error);
                    document.getElementById('paymentSuccess').style.display = 'none';
                    alert('An error occurred during payment. Please try again.');
                    document.getElementById('paymentFormContainer').classList.remove('processing');
                });
            }, 4000); // 4 seconds delay

        }, 1500); // 1.5 seconds processing time
    });

    // Prevent form resubmission on page reload
    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.href);
    }
</script>

<%@ include file="footer.jsp" %>
</body>
</html>
