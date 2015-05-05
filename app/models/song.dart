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
  bool archived = false;

  String lyrics;
  Map<int, String> chords;

  List<Songbook> songbooks;

  String tagsStr = '';

  List<SongTag> get tags {
    if(tagsStr == '')
      return [];
    var tagsSet = new Set<String>();
    var songTags = [];
    tagsStr.split(",").forEach((tag) {
      tagsSet.add(tag.trim());
    });
    tagsSet.forEach((tag) {
      songTags.add(new SongTag(tag));
    });
    return songTags;
  }

  set tags(List<SongTag> tags){
    tagsStr = "";
    if(tags != null && !tags.isEmpty) {
      tagsStr = tags[0].toString();
      for(var i = 1; i < tags.length; i++) {
        tagsStr += ", " + tags[i].toString();
      }
    }
  }

  bool contains(String other){
    if(title != null && title.toUpperCase().contains(other.toUpperCase()))
      return true;
    if(author != null && author.toUpperCase().contains(other.toUpperCase()))
      return true;
    if(originalAuthor != null && originalAuthor.toUpperCase().contains(other.toUpperCase()))
      return true;
    if(album != null && album.toUpperCase().contains(other.toUpperCase()))
      return true;
    if(year != null && year.toString().toUpperCase().contains(other.toUpperCase()))
      return true;
    if(tagsStr != null && tagsStr.toUpperCase().contains(other.toUpperCase()))
      return true;
    return false;
  }

  Song(this.title, this.album, this.author, this.originalAuthor, this.year, this.note, this.public, {this.username, this.id, this.lyrics: '', this.chords, this.songbooks, tags, this.archived}) {
    this.tags = tags;
    if (chords == null) chords = {};
    if (songbooks == null) songbooks = [];
  }
}