part of app;

/**
 * Song model.
 */
class Song {
  int id;
  String title = '';
  String album = '';
  String author = '';
  String originalAuthor = '';
  String year = '';

  String lyrics = '';
  Map<int, String> chords = {};

  Song(this.title, this.album, this.author, this.originalAuthor, this.year, {this.id, this.lyrics, this.chords});
}