part of app;

/**
 * Wish model.
 */
class Wish {
  int id;
  String name = '';
  String note = '';
  bool meet = '';
  String created = '';
  String modified = '';

  Wish({this.id, this.name, this.note, this.meet, this.created, this.modified});
}