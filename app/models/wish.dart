part of app;

/**
 * Wish model.
 */
class Wish {
  int id;
  String name = '';
  String interpret = '';
  String note = '';
  DateTime created;
  DateTime modified;

  Wish({this.id, this.name, this.interpret, this.note, this.created, this.modified});
}