📚 Library Management System (MASM + Irvine32)




A console-based Library Management System written in x86 Assembly (MASM) using the Irvine32 library. Manage books, users, and borrowing/returning operations through a menu-driven interface. Runs on Visual Studio (x86).

🛠 Features

Admin Login: Secure access with username/password (admin / admin123).

Add Book: Add new books with ID and title. Max books: 50.

Search Book: Search by ID or title; displays status and borrower.

Delete Book: Remove books by ID; shifts remaining records.

Issue Book: Issue books to users (borrow limit: 3 books).

Return Book: Return books and calculate late fines (Rs. 5/day).

View Books: See available or issued books.

Sort Books by ID: Sorts books while preserving all related data.

📊 Limits & Constants
Feature	Limit / Value
Max Books	50
Max Book Title	50 characters
Max Username / Password	20 characters
Max Borrow Limit	3 books
Fine per Day	Rs. 5
💾 Data Structures

bookIDs – Stores book IDs

bookTitles – Stores book titles

bookAvailable – Availability status (1 = available, 0 = issued)

bookBorrowerID – Tracks which user borrowed the book

bookDaysIssued – Tracks days since book was issued

userBorrowCount – Number of books each user has borrowed

⚡ Usage

Open Visual Studio with MASM support.

Create a Win32 Console Application.

Include the Irvine32 library.

Add LibraryManagement.asm to your project.

Build and run in x86 mode.

Use the console menu to navigate the system.
