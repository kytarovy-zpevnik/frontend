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
  String note = '';
  bool public = false;

  String lyrics;
  Map<int, String> chords;

  List<Songbook> songbooks;

  Song(this.title, this.album, this.author, this.originalAuthor, this.year, this.note, this.public, {this.id, this.lyrics: '', this.chords, this.songbooks}) {
    if (chords == null) chords = {
    };
    if (songbooks == null) songbooks = [];
  }
}