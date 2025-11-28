INCLUDE Irvine32.inc

.data
MAX_BOOKS EQU 50
MAX_TITLE_LEN EQU 50
MAX_USERNAME_LEN EQU 20
MAX_PASSWORD_LEN EQU 20
MAX_BORROW_LIMIT EQU 3
FINE_PER_DAY EQU 5

bookIDs DWORD MAX_BOOKS DUP(0)
bookTitles BYTE MAX_BOOKS * MAX_TITLE_LEN DUP(0)
bookAvailable BYTE MAX_BOOKS DUP(1)
bookBorrowerID DWORD MAX_BOOKS DUP(0)
bookDaysIssued DWORD MAX_BOOKS DUP(0)
bookCount DWORD 0

adminUsername BYTE "admin", 0
adminPassword BYTE "admin123", 0
currentUserID DWORD 1
userBorrowCount DWORD MAX_BOOKS DUP(0)

mainMenu BYTE "===== LIBRARY MANAGEMENT SYSTEM =====", 0Ah, 0Dh
BYTE "1. Login as Admin", 0Ah, 0Dh
BYTE "2. Add Book", 0Ah, 0Dh
BYTE "3. Search Book", 0Ah, 0Dh
BYTE "4. Delete Book", 0Ah, 0Dh
BYTE "5. Issue Book", 0Ah, 0Dh
BYTE "6. Return Book", 0Ah, 0Dh
BYTE "7. View All Available Books", 0Ah, 0Dh
BYTE "8. View Issued Books", 0Ah, 0Dh
BYTE "9. Sort Books by ID", 0Ah, 0Dh
BYTE "0. Exit", 0Ah, 0Dh
BYTE "Enter choice: ", 0

promptUsername BYTE "Enter Username: ", 0
promptPassword BYTE "Enter Password: ", 0
promptBookID BYTE "Enter Book ID: ", 0
promptBookTitle BYTE "Enter Book Title: ", 0
promptSearchType BYTE "Search by (1) ID or (2) Title? ", 0
promptUserID BYTE "Enter User ID: ", 0
promptDaysLate BYTE "Enter days late (0 if on time): ", 0

msgLoginSuccess BYTE "Login Successful!", 0Ah, 0Dh, 0
msgLoginFailed BYTE "Invalid credentials!", 0Ah, 0Dh, 0
msgBookAdded BYTE "Book added successfully!", 0Ah, 0Dh, 0
msgBookNotFound BYTE "Book not found!", 0Ah, 0Dh, 0
msgBookFound BYTE "Book Found - ID: ", 0
msgBookDeleted BYTE "Book deleted successfully!", 0Ah, 0Dh, 0
msgBookIssued BYTE "Book issued successfully!", 0Ah, 0Dh, 0
msgBookReturned BYTE "Book returned successfully!", 0Ah, 0Dh, 0
msgBookNotAvailable BYTE "Book is not available!", 0Ah, 0Dh, 0
msgBookAlreadyAvailable BYTE "Book is already available!", 0Ah, 0Dh, 0
msgLibraryFull BYTE "Library is full!", 0Ah, 0Dh, 0
msgBorrowLimit BYTE "User has reached borrow limit!", 0Ah, 0Dh, 0
msgNoBooks BYTE "No books in library!", 0Ah, 0Dh, 0
msgFineAmount BYTE "Fine Amount: Rs. ", 0
msgTitle BYTE ", Title: ", 0
msgStatus BYTE ", Status: ", 0
msgAvailable BYTE "Available", 0
msgIssued BYTE "Issued", 0
msgBorrower BYTE ", Borrower ID: ", 0
newline BYTE 0Ah, 0Dh, 0

inputBuffer BYTE MAX_TITLE_LEN DUP(0)
usernameBuffer BYTE MAX_USERNAME_LEN DUP(0)
passwordBuffer BYTE MAX_PASSWORD_LEN DUP(0)
tempNum DWORD 0
isAdmin BYTE 0

.code
main PROC
mainLoop:
call DisplayMenu
call ReadInt
mov tempNum, eax
call clrscr

cmp eax, 0
je exitProgram
cmp eax, 1
je login
cmp eax, 2
je addb
cmp eax, 3
je search
cmp eax, 4
je delete
cmp eax, 5
je issue
cmp eax, 6
je returnb
cmp eax, 7
je Available
cmp eax, 8
je Issued
cmp eax, 9
je sortByID
jmp mainLoop

login:
call LoginAdmin
jmp mainLoop

addb:
call AddBook
jmp mainLoop

search:
call SearchBook
jmp mainLoop

delete:
call DeleteBook
jmp mainLoop

issue:
call IssueBook
jmp mainLoop

returnb:
call ReturnBook
jmp mainLoop

Available:
call ViewAvailableBooks
jmp mainLoop

Issued:
call ViewIssuedBooks
jmp mainLoop

sortByID:
call SortBooksByID
jmp mainLoop

exitProgram:
exit
main ENDP

DisplayMenu PROC
call Crlf
mov edx, OFFSET mainMenu
call WriteString
ret
DisplayMenu ENDP

LoginAdmin PROC
mov edx, OFFSET promptUsername
call WriteString
mov edx, OFFSET usernameBuffer
mov ecx, MAX_USERNAME_LEN
call ReadString

mov edx, OFFSET promptPassword
call WriteString
mov edx, OFFSET passwordBuffer
mov ecx, MAX_PASSWORD_LEN
call ReadString

mov esi, OFFSET usernameBuffer
mov edi, OFFSET adminUsername
call CompareStrings
cmp eax, 0
jne loginFailed

mov esi, OFFSET passwordBuffer
mov edi, OFFSET adminPassword
call CompareStrings
cmp eax, 0
jne loginFailed

mov isAdmin, 1
mov edx, OFFSET msgLoginSuccess
call WriteString
ret

loginFailed:
mov isAdmin, 0
mov edx, OFFSET msgLoginFailed
call WriteString
ret
LoginAdmin ENDP

CompareStrings PROC
push esi
push edi

compareLoopCS:
mov al, [esi]
mov bl, [edi]
cmp al, bl
ja  greaterCS
jb  lessCS
cmp al, 0
je  equalCS
inc esi
inc edi
jmp compareLoopCS

greaterCS:
mov eax, 1
jmp doneCS

lessCS:
mov eax, 2
jmp doneCS

equalCS:
mov eax, 0

doneCS:
pop edi
pop esi
ret
CompareStrings ENDP

AddBook PROC
mov eax, bookCount
cmp eax, MAX_BOOKS
jge libraryFull

mov edx, OFFSET promptBookID
call WriteString
call ReadInt
mov tempNum, eax

mov eax, bookCount
mov ebx, 4
mul ebx
mov esi, eax
mov eax, tempNum
mov bookIDs[esi], eax

mov edx, OFFSET promptBookTitle
call WriteString
mov edx, OFFSET inputBuffer
mov ecx, MAX_TITLE_LEN
call ReadString

mov eax, bookCount
mov ebx, MAX_TITLE_LEN
mul ebx
mov edi, eax
lea edi, bookTitles[edi]
mov esi, OFFSET inputBuffer
call CopyString

mov eax, bookCount
mov bookAvailable[eax], 1
mov ebx, 4
mul ebx
mov bookBorrowerID[eax], 0
mov bookDaysIssued[eax], 0

inc bookCount

mov edx, OFFSET msgBookAdded
call WriteString
ret

libraryFull:
mov edx, OFFSET msgLibraryFull
call WriteString
ret
AddBook ENDP

CopyString PROC
push esi
push edi

copyLoop:
mov al, [esi]
mov [edi], al
cmp al, 0
je copyEnd
inc esi
inc edi
jmp copyLoop

copyEnd:
pop edi
pop esi
ret
CopyString ENDP

SearchBook PROC
cmp bookCount, 0
je noBooks

mov edx, OFFSET promptSearchType
call WriteString
call ReadInt
mov tempNum, eax

cmp eax, 1
je searchByID
cmp eax, 2
je searchByTitle
ret

searchByID:
mov edx, OFFSET promptBookID
call WriteString
call ReadInt
mov tempNum, eax

mov ecx, bookCount
mov esi, 0
searchIDLoop:
mov eax, esi
mov ebx, 4
mul ebx
mov eax, bookIDs[eax]
cmp eax, tempNum
je foundByID
inc esi
loop searchIDLoop
jmp notFound

foundByID:
call DisplayBookDetails
ret

searchByTitle:
mov edx, OFFSET promptBookTitle
call WriteString
mov edx, OFFSET inputBuffer
mov ecx, MAX_TITLE_LEN
call ReadString

mov ecx, bookCount
mov esi, 0
searchTitleLoop:
push ecx
mov eax, esi
mov ebx, MAX_TITLE_LEN
mul ebx
lea edi, bookTitles[eax]
push esi
mov esi, OFFSET inputBuffer
call CompareStrings
pop esi
cmp eax, 0
je foundByTitle
inc esi
pop ecx
loop searchTitleLoop
jmp notFound

foundByTitle:
pop ecx
call DisplayBookDetails
ret

notFound:
mov edx, OFFSET msgBookNotFound
call WriteString
ret

noBooks:
mov edx, OFFSET msgNoBooks
call WriteString
ret
SearchBook ENDP

DisplayBookDetails PROC
mov edx, OFFSET msgBookFound
call WriteString

mov eax, esi
push esi
mov ebx, 4
mul ebx
mov eax, bookIDs[eax]
call WriteDec
pop esi

mov edx, OFFSET msgTitle
call WriteString
push esi
mov eax, esi
mov ebx, MAX_TITLE_LEN
mul ebx
lea edx, bookTitles[eax]
call WriteString
pop esi

mov edx, OFFSET msgStatus
call WriteString
push esi
mov al, bookAvailable[esi]
cmp al, 1
je displayAvailable
mov edx, OFFSET msgIssued
call WriteString

mov edx, OFFSET msgBorrower
call WriteString
mov eax, esi
mov ebx, 4
mul ebx
mov eax, bookBorrowerID[eax]
call WriteDec
jmp endDisplay

displayAvailable:
mov edx, OFFSET msgAvailable
call WriteString

endDisplay:
pop esi
mov edx, OFFSET newline
call WriteString
ret
DisplayBookDetails ENDP

DeleteBook PROC
cmp bookCount, 0
je noBooks

mov edx, OFFSET promptBookID
call WriteString
call ReadInt
mov tempNum, eax

mov ecx, bookCount
mov esi, 0
findLoop:
mov eax, esi
shl eax, 2
mov eax, bookIDs[eax]
cmp eax, tempNum
je foundBook
inc esi
loop findLoop
jmp notFound

foundBook:
mov ecx, bookCount
dec ecx
sub ecx, esi
cmp ecx, 0
je lastBook

shiftLoop:
push ecx

mov eax, esi
inc eax
shl eax, 2
mov edx, bookIDs[eax]
mov eax, esi
shl eax, 2
mov bookIDs[eax], edx

mov eax, esi
inc eax
shl eax, 2
mov edx, bookBorrowerID[eax]
mov eax, esi
shl eax, 2
mov bookBorrowerID[eax], edx

mov eax, esi
inc eax
shl eax, 2
mov edx, bookDaysIssued[eax]
mov eax, esi
shl eax, 2
mov bookDaysIssued[eax], edx

mov al, bookAvailable[esi+1]
mov bookAvailable[esi], al

push esi
mov eax, esi
mov ebx, MAX_TITLE_LEN
mul ebx
lea edi, bookTitles[eax]
mov eax, esi
inc eax
mul ebx
lea esi, bookTitles[eax]
call CopyString
pop esi

inc esi
pop ecx
loop shiftLoop

lastBook:
dec bookCount
mov edx, OFFSET msgBookDeleted
call WriteString
ret

notFound:
mov edx, OFFSET msgBookNotFound
call WriteString
ret

noBooks:
mov edx, OFFSET msgNoBooks
call WriteString
ret
DeleteBook ENDP

IssueBook PROC
cmp bookCount, 0
je noBooks

mov edx, OFFSET promptBookID
call WriteString
call ReadInt
mov tempNum, eax

mov ecx, bookCount
mov esi, 0
findBookLoop:
mov eax, esi
mov ebx, 4
mul ebx
mov eax, bookIDs[eax]
cmp eax, tempNum
je bookFoundForIssue
inc esi
loop findBookLoop
jmp bookNotFound

bookFoundForIssue:
mov al, bookAvailable[esi]
cmp al, 1
jne bookNotAvailable

mov edx, OFFSET promptUserID
call WriteString
call ReadInt
mov currentUserID, eax

mov ebx, 4
mul ebx
mov edx, userBorrowCount[eax]
cmp edx, MAX_BORROW_LIMIT
jge borrowLimitReached

mov bookAvailable[esi], 0
mov eax, esi
mov ebx, 4
mul ebx
mov edx, currentUserID
mov bookBorrowerID[eax], edx
mov bookDaysIssued[eax], 0

mov eax, currentUserID
mov ebx, 4
mul ebx
inc userBorrowCount[eax]

mov edx, OFFSET msgBookIssued
call WriteString
ret

bookNotAvailable:
mov edx, OFFSET msgBookNotAvailable
call WriteString
ret

bookNotFound:
mov edx, OFFSET msgBookNotFound
call WriteString
ret

borrowLimitReached:
mov edx, OFFSET msgBorrowLimit
call WriteString
ret

noBooks:
mov edx, OFFSET msgNoBooks
call WriteString
ret
IssueBook ENDP

ReturnBook PROC
cmp bookCount, 0
je noBooks

mov edx, OFFSET promptBookID
call WriteString
call ReadInt
mov tempNum, eax

mov ecx, bookCount
mov esi, 0
findReturnLoop:
mov eax, esi
mov ebx, 4
mul ebx
mov eax, bookIDs[eax]
cmp eax, tempNum
je bookFoundForReturn
inc esi
loop findReturnLoop
jmp bookNotFound

bookFoundForReturn:
mov al, bookAvailable[esi]
cmp al, 0
jne bookAlreadyAvailable

mov edx, OFFSET promptDaysLate
call WriteString
call ReadInt
mov tempNum, eax

cmp eax, 0
jle noFine
mov ebx, FINE_PER_DAY
mul ebx
mov edx, OFFSET msgFineAmount
push eax
call WriteString
pop eax
call WriteDec
mov edx, OFFSET newline
call WriteString

noFine:
mov bookAvailable[esi], 1

mov eax, esi
mov ebx, 4
mul ebx
mov edx, bookBorrowerID[eax]
mov bookBorrowerID[eax], 0
mov bookDaysIssued[eax], 0

mov eax, edx
mov ebx, 4
mul ebx
dec userBorrowCount[eax]

mov edx, OFFSET msgBookReturned
call WriteString
ret

bookAlreadyAvailable:
mov edx, OFFSET msgBookAlreadyAvailable
call WriteString
ret

bookNotFound:
mov edx, OFFSET msgBookNotFound
call WriteString
ret

noBooks:
mov edx, OFFSET msgNoBooks
call WriteString
ret
ReturnBook ENDP

ViewAvailableBooks PROC
cmp bookCount, 0
je noBooks

mov ecx, bookCount
mov esi, 0
viewLoop:
push ecx
mov al, bookAvailable[esi]
cmp al, 1
jne skipBook
call DisplayBookDetails

skipBook:
inc esi
pop ecx
loop viewLoop
ret

noBooks:
mov edx, OFFSET msgNoBooks
call WriteString
ret
ViewAvailableBooks ENDP

ViewIssuedBooks PROC
cmp bookCount, 0
je noBooks

mov ecx, bookCount
mov esi, 0
viewIssuedLoop:
push ecx
mov al, bookAvailable[esi]
cmp al, 0
jne skipIssuedBook
call DisplayBookDetails

skipIssuedBook:
inc esi
pop ecx
loop viewIssuedLoop
ret

noBooks:
mov edx, OFFSET msgNoBooks
call WriteString
ret
ViewIssuedBooks ENDP

SortBooksByID PROC
cmp bookCount, 1
jle noSortID

mov ecx, bookCount
dec ecx

outerLoopID:
push ecx
mov esi, 0

innerLoopID:
mov eax, esi
shl eax, 2
mov eax, bookIDs[eax]

mov edx, esi
inc edx
shl edx, 2
mov edx, bookIDs[edx]

cmp eax, edx
jle noSwapID

push ecx
push esi
call SwapBooks
pop esi
pop ecx

noSwapID:
inc esi
loop innerLoopID

pop ecx
loop outerLoopID

noSortID:
ret
SortBooksByID ENDP

SwapBooks PROC
pushad

mov ecx, esi

mov eax, ecx
shl eax, 2
mov edx, [bookIDs + eax]
mov ebx, eax
add ebx, 4
mov esi, [bookIDs + ebx]
mov [bookIDs + eax], esi
mov [bookIDs + ebx], edx

mov edx, [bookBorrowerID + eax]
mov esi, [bookBorrowerID + ebx]
mov [bookBorrowerID + eax], esi
mov [bookBorrowerID + ebx], edx

mov edx, [bookDaysIssued + eax]
mov esi, [bookDaysIssued + ebx]
mov [bookDaysIssued + eax], esi
mov [bookDaysIssued + ebx], edx

mov al, bookAvailable[ecx]
mov dl, bookAvailable[ecx + 1]
mov bookAvailable[ecx], dl
mov bookAvailable[ecx + 1], al

mov eax, ecx
mov ebx, MAX_TITLE_LEN
mul ebx
lea esi, bookTitles[eax]

mov edi, OFFSET inputBuffer
call CopyString

mov eax, ecx
inc eax
mov ebx, MAX_TITLE_LEN
mul ebx
lea esi, bookTitles[eax]

mov eax, ecx
mov ebx, MAX_TITLE_LEN
mul ebx
lea edi, bookTitles[eax]
call CopyString

mov esi, OFFSET inputBuffer
mov eax, ecx
inc eax
mov ebx, MAX_TITLE_LEN
mul ebx
lea edi, bookTitles[eax]
call CopyString

popad
ret
SwapBooks ENDP

END main


