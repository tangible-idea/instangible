
// {
// "_id": "__7E1LEXGN_0",
// "content": "Spread love everywhere you go. Let no one ever come to you without leaving happier.",
// "author": "Mother Teresa",
// "tags": [
// "Famous Quotes"
// ],
// "authorSlug": "mother-teresa",
// "length": 83,
// "dateAdded": "2020-01-26",
// "dateModified": "2023-04-14"
// }

//class _id;

class Quote {
  String? id;
  String? content;
  String? author;

  Quote({
    this.id,
    this.content,
    this.author,
  });
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json["_id"],
        content: json["content"],
        author: json["author"]);
    }
}