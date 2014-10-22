part of app;

/**
 * Songbook model.
 */
class Songbook {
  final int id;
  String name;
  List songs = [];

  Songbook(this.id, this.name, {this.songs});


}