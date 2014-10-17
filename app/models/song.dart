part of app;

/**
 * Song model.
 */
class Song {
  final int id;
  String title;
  String album;
  String author;
  String originalAuthor;
  Int year;


  Song(this.id, this.title, this.album, this.author, this.originalAuthor, this.year);
}