<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Library System</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather :wght@400;700&family=Open+Sans&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #1d2a35;
            color: #f5f5f5;
            font-family: 'Open Sans', sans-serif;
            padding: 40px;
            line-height: 1.6;
        }

        h2, h3 {
            text-align: center;
            color: #f5c776;
            margin-bottom: 20px;
        }

        .contact-container {
            max-width: 1000px;
            margin: auto;
            background-color: #121e2a;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            padding: 30px;
        }

        .contact-layout {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
        }

        .contact-info,
        .map-section {
            flex: 1;
            min-width: 300px;
        }

        .contact-info p {
            margin: 10px 0;
        }

        .map-section iframe {
            width: 100%;
            height: 300px;
            border: none;
            border-radius: 8px;
            flex: 1;
        }

        .social-links {
            margin-top: 30px;
            text-align: center;
        }

        .social-links a {
            color: #f5c776;
            text-decoration: none;
            margin: 0 10px;
            font-weight: bold;
        }

        .social-links a:hover {
            text-decoration: underline;
        }

        .footer {
            text-align: center;
            margin-top: 50px;
        }

        .footer a {
            color: #f5c776;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="contact-container">
        <h2>Contact Us</h2>

        <div class="contact-layout">
            <!-- Left Side: Contact Info -->
            <div class="contact-info">
                <p><strong>Library Name:</strong> Library Hub</p>
                <p><strong>Email:</strong> libraryHub@gmail.com</p>
                <p><strong>Phone:</strong> 067 072 9097</p>
                <p><strong>Address:</strong> Mandela St, eMalahleni, 1034<br>
                   Tshwane University of Technology eMalahleni Campus</p>
                <p><strong>Hours:</strong><br>
                   Mon-Fri: 7AM–10PM<br>
                   Sat: 10AM–2PM</p>
            </div>

            <!-- Right Side: Google Map -->
            <div class="map-section">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3589.7505182838067!2d29.233938075404286!3d-25.877687277279254!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x1eeaf2a1ea314d53%3A0x47c38dbef5ec47d0!2sTshwane%20University%20of%20Technology%20eMalahleni%20Campus!5e0!3m2!1sen!2sza!4v1747709711023!5m2!1sen!2sza" 
                        allowfullscreen="" 
                        loading="lazy" 
                    referrerpolicy="no-referrer-when-downgrade">
                            
                </iframe>
            </div>
        </div>

        <!-- Social Links Below -->
        <div class="social-links">
            <h3 style="margin-top: 30px;">🌐 Follow Us</h3>
            <a href="https://www.facebook.com/tutlibrary " target="_blank">📘 Facebook</a> |
            <a href="https://twitter.com/tutlibrary " target="_blank">📘 Twitter/X</a> |
            <a href="https://instagram.com/tutlibrary " target="_blank">📘 Instagram</a> |
       
        </div>
    </div>

    <div class="footer">
        <p><a href="index.html">Back to Home Page</a></p>
    </div>

</body>
</html>