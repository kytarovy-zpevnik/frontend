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
  List songs = [];
  String tagsStr = '';
  bool archived = false;

  List<SongbookTag> get tags {
    if(tagsStr == '')
      return [];
    List<SongbookTag> res = new List<SongbookTag>();
    var tagSet = tagsStr.split(",").toSet();
    for(var tag in tagSet) {
      res.add(new SongbookTag(tag));
    }
    return res;
  }

  set tags(List<SongbookTag> tags){
    tagsStr = "";
    if(tags != null && !tags.isEmpty) {
      tagsStr = tags[0].toString();
      for(var i = 1; i < tags.length; i++) {
        tagsStr += "," + tags[i].toString();
      }
    }
  }

  Songbook(this.id, this.name, this.note, {this.public, this.songs, this.username, tags, this.archived}) {
    this.tags = tags;
  }
}