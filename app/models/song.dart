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
  String privateTagsStr = '';

  List<SongTag> get tags {
    var songTags = [];
    if(tagsStr != ''){
      tagsStr.split(",").forEach((tag) {
        songTags.add(new SongTag(tag.trim(), true));
      });
    }
    if(privateTagsStr != ''){
      privateTagsStr.split(",").forEach((tag) {
        songTags.add(new SongTag(tag.trim(), false));
      });
    }
    return songTags;
  }

  set tags(List<SongTag> tags){
    tagsStr = '';
    privateTagsStr = '';
    if(tags != null) {
      for(int i = 0; i < tags.length; i++){
        if(tags[i].public){
          if(tagsStr != '')
            tagsStr += ', ';
          tagsStr += tags[i].tag;
        }
        else{
          if(privateTagsStr != '')
            privateTagsStr += ', ';
          privateTagsStr += tags[i].tag;
        }
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