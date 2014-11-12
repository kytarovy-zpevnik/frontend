part of app;

/**
 * Comment model.
 */
class Comment {
  int id;
  String comment = '';
  DateTime created = '';
  DateTime modified = '';
  String username = '';

  Comment({this.id, this.comment, this.created, this.modified, this.username});
}