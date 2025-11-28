Library Management System (MASM + Irvine32)

This project is a Library Management System implemented in x86 Assembly (MASM) using the Irvine32 library. It allows managing books, users, and borrowing/returning operations with simple menu-driven functionality. The program is designed to run in Visual Studio (x86).

Features

Admin Login

Allows admin to log in using a username and password (admin / admin123).

Provides access to manage books and issue/return operations.

Add Book

Admin can add new books to the library.

Each book has a unique ID, title, and availability status.

Maximum number of books: 50.

Search Book

Search by Book ID or Book Title.

Displays book details including status and borrower if issued.

Delete Book

Admin can delete a book by ID.

Handles array shifting to remove the book from the system.

Issue Book

Books can be issued to users with a unique User ID.

Enforces a borrow limit of 3 books per user.

Updates book availability and borrower information.

Return Book

Users can return books and input late days.

Calculates fines at Rs. 5 per day if late.

Updates book availability and borrower count.

View Books

Available Books: Shows all books that are currently available.

Issued Books: Shows all books that are currently issued.

Sort Books by ID

Implements bubble sort to sort books based on their ID.

Updates all associated book data during sorting.

Constants & Limits

Maximum books: 50

Maximum book title length: 50 characters

Maximum username/password length: 20 characters

Maximum borrow limit per user: 3 books

Fine per day: Rs. 5

Data Structures

bookIDs: DWORD array storing book IDs

bookTitles: BYTE array storing book titles

bookAvailable: BYTE array for availability status (1 = available, 0 = issued)

bookBorrowerID: DWORD array for borrower IDs

bookDaysIssued: DWORD array for tracking days issued

userBorrowCount: DWORD array storing number of books borrowed per user

How to Run

Open Visual Studio with MASM support.

Create a Win32 Console Application.

Include the Irvine32 library.

Add LibraryManagement.asm to your project.

Build and run the project in x86 mode.

Interact with the program using the menu.
