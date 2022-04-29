class BookModel {
  String? bookId;
  String? bookName;
  String? bookQty;
  String? bookAuthor;

  BookModel({
    this.bookAuthor,
    this.bookName,
    this.bookQty,
    this.bookId,
  });

  BookModel.fromMap(Map<String, dynamic> map) {
    bookAuthor = map["bookAuthor"];
    bookName = map["bookName"];
    bookId = map["bookId"];
    bookQty = map["bookQty"];
  }

  Map<String, dynamic> toMap() {
    return {
      "bookAuthor": bookAuthor,
      "bookId": bookId,
      "bookQty": bookQty,
      "bookName": bookName,
    };
  }
}
