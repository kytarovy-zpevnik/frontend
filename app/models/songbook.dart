part of app;

/**
 * Songbook model.
 */
class Songbook {
  int id;
  String name;
  String note = '';
  String username = '';
  bool public = false;
  List songs = [];

  Songbook(this.id, this.name, this.note, this.public, {this.songs, this.username});


}