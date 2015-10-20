part of app;

/**
 * SongbookTag model.
 */
class SongbookTag {
  String tag;
  bool public;

  SongbookTag(this.tag, this.public) {
  }

  toString() => tag;
}
