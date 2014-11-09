part of app;

/**
 * Songbook model.
 */
class Songbook {
  int id;
  String name;
  String note = '';
  bool public = false;
  List songs = [];

  Songbook(this.id, this.name, this.note, this.public, {this.songs});


}