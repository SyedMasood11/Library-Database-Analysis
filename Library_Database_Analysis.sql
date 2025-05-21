-- LIBRARY DATABASE ANALYSIS
/* 
THIS DATABASE CONTAINS THE DATA OF RECORDS 
OF A LIBRARY. WHICH HAS INFORMATION ABOUT THE
PULISHERS, AUTHORS OF BOOKS, NUMBER OF BOOKS AVAILABLE,
BOOKS LOANED AND OTHER RELEVANT INFORMATION
*/ 
create database Library_database;
use library_database;
-- CREATING TABLES
-- AUTHOR
create table Authors (
book_authors_BookID int,
book_authors_AuthorName varchar (100),
foreign key (book_authors_BookID) references Books(book_BookID)
on update cascade
on delete cascade);
-- BOOKS TABLE
create table Books(book_BookID int primary key auto_increment,
book_Title varchar(200),
book_PublisherName varchar (200),
foreign key (book_PublisherName) references Publishers(publisher_PublisherName)
on update cascade
on delete cascade);
-- PUBLISHERS TABLE
create table Publishers(publisher_PublisherName varchar(200) primary key,
publisher_PublisherAddress varchar(200),
publisher_PublisherPhone varchar(200));
-- BOOK_COPIES TABLE
create table Book_Copies(
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key (book_copies_BookID) references Books(book_BookID),
foreign key (book_copies_BranchID) references library_branch(library_branch_id) 
on update cascade
on delete cascade);
-- LIBRARY BRANCH
create table Library_branch(library_branch_id int primary key auto_increment, 
library_branch_BranchName varchar(100),
library_branch_BranchAddress varchar (100));
-- Borrower
create table Borrower(borrower_CardNo int primary key,
borrower_BorrowerName varchar(200),
borrower_BorrowerAddress varchar(200),
borrower_BorrowerPhone varchar(200));
-- BOOK LOANS
create table Book_loans(
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut varchar(100),
book_loans_DueDate varchar(100),
foreign key (book_loans_BookID) references Books(book_BookID),
foreign key (book_loans_BranchID) references Library_branch(library_branch_id),
foreign key (book_loans_CardNo) references Borrower(borrower_CardNo)
on update cascade
on delete cascade);

-- CHECK THE UPDATED TABLE
select * from authors;
select * from books;
select * from publishers;
select * from borrower;
select * from library_branch;
select * from book_Copies;
select * from book_loans;

/* CHANGING THE DATE COLUMNS OF BOOK_LOANS TABLE
TO STANDARD DATE FORMAT */
SELECT STR_TO_DATE(book_loans_DateOut, '%m/%d/%Y') AS formatted_date
FROM book_loans;
update book_loans
set book_loans_DateOut = STR_TO_DATE(book_loans_DateOut, '%m/%d/%Y');
update book_loans
set book_loans_DueDate = STR_TO_DATE(book_loans_DueDate, '%m/%d/%Y');

select * from book_loans;

-- Task Questions


/* 
1 How many copies of the book titled "The Lost Tribe" are owned 
by the library branch whose name is "Sharpstown"?
*/
select book_BookID,Book_title,book_copies_No_Of_Copies,library_branch_id,library_branch_BranchName from books b
left join book_copies bc
join library_branch lb
on lb.library_branch_id = bc.book_copies_BranchID
on b.book_bookID = bc.book_copies_BookID
where library_branch_BranchName = 'Sharpstown'
having book_title = 'The Lost Tribe';


/*
2 How many copies of the book titled 
"The Lost Tribe" are owned by each library branch?
*/
select library_branch_id,library_branch_BranchName,Book_title,book_copies_No_Of_Copies from books b
left join book_copies bc
join library_branch lb
on lb.library_branch_id = bc.book_copies_BranchID
on b.book_bookID = bc.book_copies_BookID
having book_title = 'The Lost Tribe';


/*
3 Retrieve the names of all borrowers
who do not have any books checked out.
*/

select borrower_BorrowerName,count(*) as No_books_checked from borrower b
join book_loans bl
on b.borrower_CardNo = bl.book_loans_CardNo
group by borrower_BorrowerName;
select * from borrower; -- (THRE ARE NO BORROWERS WHO HAVE NOT CHECKED ANY BOOKS)

/* 
4 For each book that is loaned out from the "Sharpstown" branch 
and whose DueDate is 2/3/18, retrieve the book title, 
the borrower's name, and the borrower's address. 
*/

with cte_1 as(
select * from books bk
join book_loans bl
join library_branch lb
on bl.book_loans_BranchID = lb.library_branch_id
on bk.book_BookID = bl.book_loans_BookID
where lb.library_branch_BranchName = 'Sharpstown'
having bl.book_loans_DueDate = '2018-02-03')
select book_Title,
borrower_BorrowerName,
borrower_BorrowerAddress,
book_loans_DueDate,library_branch_BranchName
from cte_1
join borrower b
on book_loans_CardNo = b.borrower_CardNo ;


/*
5 For each library branch, retrieve the branch name
and the total number of books loaned out from that branch.
*/

select library_branch_BranchName,count(*) as books_loaned_per_branch from library_branch lb
join book_loans bl
on lb.library_branch_id = bl.book_loans_BranchID
group by library_branch_BranchName ;

/* 
6) Retrieve the names, addresses, and number of books checked out for all borrowers 
who have more than five books checked out.
*/

select borrower_BorrowerName,count(*) as No_books_checked from borrower b
join book_loans bl
on b.borrower_CardNo = bl.book_loans_CardNo
group by borrower_BorrowerName
having No_books_checked > 5;


/* 
7) For each book authored by "Stephen King",
retrieve the title and the number of copies 
owned by the library branch whose name is "Central".
*/

select library_branch_id,library_branch_BranchName,book_Title,
book_copies_No_Of_Copies,book_authors_AuthorName from authors a
join books b
join book_copies bc
join library_branch lb
on bc.book_copies_BranchID = lb.library_branch_id
on b.book_BookID = bc.book_copies_BookID
on a.book_authors_BookID = b.book_BookID
where book_authors_AuthorName = 'Stephen King'
having library_branch_BranchName = 'Central';
