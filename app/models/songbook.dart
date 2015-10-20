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
  bool archived = false;
  List songs = [];
  String tagsStr = '';
  String privateTagsStr = '';

  List<SongbookTag> get tags {
    var songbookTags = [];
    if(tagsStr != ''){
      tagsStr.split(",").forEach((tag) {
        songbookTags.add(new SongbookTag(tag.trim(), true));
      });
    }
    if(privateTagsStr != ''){
      privateTagsStr.split(",").forEach((tag) {
        songbookTags.add(new SongbookTag(tag.trim(), false));
      });
    }
    return songbookTags;
  }

  set tags(List<SongbookTag> tags){
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
    if(name != null && name.toUpperCase().contains(other.toUpperCase()))
      return true;
    if(tagsStr != null && tagsStr.toUpperCase().contains(other.toUpperCase()))
      return true;
    return false;
  }

  Songbook(this.id, this.name, this.note, {this.public, this.songs, this.username, tags, this.archived}) {
    this.tags = tags;
  }
}