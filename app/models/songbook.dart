part of app;

/**
 * Songbook model.
 */
class Songbook {
  int id;
  String name;
  String note = '';
  List songs = [];

  Songbook(this.id, this.name, this.note, {this.songs});


}