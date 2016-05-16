part of app;

/**
 * Rating model.
 */
class Rating {
  int id;
  String comment = '';
  DateTime modified;
  DateTime created;
  int rating;
  int userId;
  String username;

  Rating({this.id, this.comment, this.created, this.modified, this.rating, this.userId, this.username});
}