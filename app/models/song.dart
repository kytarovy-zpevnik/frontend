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
  String username = '';

  String lyrics;
  Map<int, String> chords;

  List<Songbook> songbooks;

  String tagsStr = '';

  List<Tag> get tags {
    if(tagsStr == '')
      return [];
    List<Tag> res = new List<Tag>();
    var tagSet = tagsStr.split(",").toSet();
    for(var tag in tagSet) {
      res.add(new Tag(tag));
    }
    return res;
  }

  set tags(List<Tag> tags){
    tagsStr = "";
    if(tags != null && !tags.isEmpty) {
      tagsStr = tags[0].toString();
      for(var i = 1; i < tags.length; i++) {
        tagsStr += "," + tags[i].toString();
      }
    }
  }

  Song(this.title, this.album, this.author, this.originalAuthor, this.year, this.note, this.public, {this.username, this.id, this.lyrics: '', this.chords, this.songbooks, tags}) {
    this.tags = tags;
    if (chords == null) chords = {};
    if (songbooks == null) songbooks = [];
    if (tags == null) tags = [];
  }
}