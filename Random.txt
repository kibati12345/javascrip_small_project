// Library Code
function createLibrary() {
    return {
        books: [],

        addBook(title, author) {
            this.books.push({ title, author, isAvailable: true });
        },

        borrowBook(title) {
            const book = this.books.find(book => book.title === title);
            if (!book) {
                return `Book "${title}" not found in the library.`;
            }
            if (!book.isAvailable) {
                return `Book "${title}" is already borrowed.`;
            }
            book.isAvailable = false;
            return `You have successfully borrowed "${title}".`;
        },

        returnBook(title) {
            const book = this.books.find(book => book.title === title);
            if (!book) {
                return `Book "${title}" not found in the library.`;
            }
            if (book.isAvailable) {
                return `Book "${title}" is already in the library.`;
            }
            book.isAvailable = true;
            return `You have successfully returned "${title}".`;
        },

        listAvailableBooks() {
            const availableBooks = this.books.filter(book => book.isAvailable);
            if (availableBooks.length === 0) {
                return "No books are currently available.";
            }
            return availableBooks.map(book => `"${book.title}" by ${book.author}`).join("\n");
        }
    };
}

// Instantiate the library
const library = createLibrary();

// Helper function to display messages
function displayMessage(message) {
    const outputDiv = document.getElementById('output');
    const result = document.createElement('div');
    result.className = 'result';
    result.textContent = message;
    outputDiv.appendChild(result);
}

// Event: Add a Book
document.getElementById('addBookForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const title = document.getElementById('addTitle').value;
    const author = document.getElementById('addAuthor').value;
    library.addBook(title, author);
    displayMessage(`Book "${title}" by ${author} added to the library.`);
});

// Event: Borrow a Book
document.getElementById('borrowBookForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const title = document.getElementById('borrowTitle').value;
    const message = library.borrowBook(title);
    displayMessage(message);
});

// Event: Return a Book
document.getElementById('returnBookForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const title = document.getElementById('returnTitle').value;
    const message = library.returnBook(title);
    displayMessage(message);
});

// Event: List Available Books
document.getElementById('listBooksButton').addEventListener('click', function () {
    const availableBooks = library.listAvailableBooks();
    displayMessage(availableBooks || "No books are currently available.");
});
