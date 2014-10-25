part of app;

/**
 * Songbook model.
 */
class Songbook {
  int id;
  String name;
  List songs = [];

  Songbook(this.id, this.name, {this.songs});


}