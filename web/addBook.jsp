<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add New Book</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            margin: 0;
            padding: 0;
            padding-top: 80px;
        }

        h1 {
            font-family: 'Merriweather', serif;
            text-align: center;
            color: #f5c776;
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        form {
            max-width: 600px;
            margin: auto;
            background-color: #121e2a;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        label {
            display: block;
            font-size: 1.1rem;
            color: #f5f5f5;
            margin-bottom: 6px;
        }

        input[type="text"],
        select,
        input[type="file"] {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f5f5f5;
            color: #333;
        }

        .error {
            color: #ff6f61;
            font-size: 0.95rem;
            margin-top: -14px;
            margin-bottom: 12px;
            display: none;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            font-size: 1.2rem;
            background-color: #f5c776;
            color: #1d2a35;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #ffdb70;
        }

        .footer {
            text-align: center;
            margin-top: 50px;
        }

        .footer a {
            color: #f5c776;
            font-size: 1rem;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            form {
                width: 90%;
                padding: 20px;
            }

            h1 {
                font-size: 1.5rem;
            }
        }
    </style>

    <script>
        function validateForm() {
            let isValid = true;

            // Clear all error messages
            document.querySelectorAll(".error").forEach(e => e.style.display = "none");

            const title = document.getElementById("title").value.trim();
            const author = document.getElementById("author").value.trim();
            const isbn = document.getElementById("isbn").value.trim();
            const category = document.getElementById("category").value;
            const isbnPattern = /^[0-9]{8,11}$/;
            const authorPattern = /^[A-Za-z\s]+$/;

            if (!isbnPattern.test(isbn)) {
                document.getElementById("isbnError").style.display = "block";
                isValid = false;
            }

            if (!authorPattern.test(author)) {
                document.getElementById("authorError").style.display = "block";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>
<body>

    <h1>Add New Book</h1>
    <form action="addBooksServlet.do" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
        <label for="title">Book Title:</label>
        <input type="text" id="title" name="title" required>

        <label for="author">Author:</label>
        <input type="text" id="author" name="author" required>
        <div class="error" id="authorError">Author name must only contain letters and spaces.</div>

        <label for="isbn">ISBN:</label>
        <input type="text" id="isbn" name="isbn" required>
        <div class="error" id="isbnError">ISBN must be a number with 8 to 11 digits.</div>

        <label for="category">Category:</label>
        <select id="category" name="category" required>
            <option value="" disabled selected>Choose category</option>
            <option value="Computer Science">Computer Science</option>
            <option value="Engineering">Engineering</option>
            <option value="Mathematics">Mathematics</option>
            <option value="Literature">Literature</option>
            <option value="History">History</option>
            <option value="Science">Science</option>
            <option value="Fantasy">Fantasy</option>
            <option value="Horror">Horror</option>
            <option value="Romance">Romance</option>
            <option value="Thriller">Thriller</option>
        </select>

        <label for="status">Status:</label>
        <select id="status" name="status">
            <option value="Available" selected>Available</option>
            <option value="Borrowed">Borrowed</option>
            <option value="Reserved">Reserved</option>
        </select>

        <label for="cover">Book Cover:</label>
        <input type="file" id="cover" name="cover" accept="image/*" required>

        <input type="submit" value="Add Book">
    </form>

    <div class="footer">
        <p><a href="dashboard.jsp">Back to Dashboard</a></p>
    </div>

</body>
</html>
