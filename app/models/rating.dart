part of app;

/**
 * Rating model.
 */
class Rating {
  int id;
  String comment = '';
  String created = '';
  String modified = '';
  int rating;
  int userId;

  Rating({this.id, this.comment, this.created, this.modified, this.rating, this.userId});
}