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
  int rating = 0;
  int numOfRating = 0;
  int posInSongbook;
  bool taken = false;
  int copy = null;
  bool old = false;

  String _lyrics = '';
  String get lyrics => _lyrics;

  set lyrics(String text) {
    int lenDiff = text.length - _lyrics.length;
    int offset = _findDiff(text, _lyrics);

    List<String> keys = chords.keys.toList();
    keys.sort((int a, int b){
      if (int.parse(a) > int.parse(b))
        return -lenDiff;
      if (int.parse(b) > int.parse(a))
        return lenDiff;
      return 0;
    });
    keys.forEach((String pos){
      int position = int.parse(pos);
      if(position < offset)
        return;
      if(lenDiff > 0 || position >= offset - lenDiff) {
        chords[(position + lenDiff).toString()] = chords[position.toString()];
      }
      chords.remove(position.toString());
    });

    _lyrics = text;
  }

  Map<String, String> chords;

  List<Songbook> songbooks;

  String tagsStr = '';
  String privateTagsStr = '';

  List<Tag> get tags {
    var songTags = [];
    if(tagsStr != ''){
      tagsStr.split(",").forEach((tag) {
        songTags.add(new Tag(tag.trim(), true));
      });
    }
    if(privateTagsStr != ''){
      privateTagsStr.split(",").forEach((tag) {
        songTags.add(new Tag(tag.trim(), false));
      });
    }
    return songTags;
  }

  set tags(List<Tag> tags){
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

  Song(this.title, this.album, this.author, this.year, this.public,
       {this.originalAuthor, this.note, this.username, this.id, lyrics, this.chords, this.songbooks,
       tags, this.archived, this.rating, this.taken, this.copy, this.numOfRating, this.old, this.posInSongbook}) {
    this.tags = tags;
    if (lyrics != null) this._lyrics = lyrics;
    if (chords == null) chords = {};
    if (songbooks == null) songbooks = [];
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

  bool isInSongbook(int songbook){
    var contains = false;
    this.songbooks.forEach((Songbook songsongbook) {
      if (songbook == songsongbook.id) {
        contains = true;
      }
    });
    return contains;
  }

  int _findDiff(String a, String b) {
    for (var i = 0; i < min(a.length, b.length); i++) {
      if (a.substring(i, i+1) != b.substring(i, i+1)) {
        return i;
      }
    }
    return min(a.length, b.length);
  }

  List computeLyrics() {
    var offset = 0;

    var sections = [];

    if(!_lyrics.isEmpty) {
      this._lyrics.split('\n\n').forEach((String section) {
        if (!sections.isEmpty)
          offset += 2;
        // count in delimiting \n\n

        var sectionOffset = section.indexOf('))');
        var title = '';

        if (section.indexOf('((') == 0 && sectionOffset != -1) {
          //print(rowOffset);
          title = section.substring(2, sectionOffset) + ':';
          sectionOffset += 2;
        } else {
          sectionOffset = 0;
        }

        bool chordOnFirstLine;
        var lines = [];
        section.substring(sectionOffset).split('\n').forEach((String line) {
          if (!lines.isEmpty)
            offset++;
          // count in delimiting \n

          int endlineOffset = offset + line.length;
          var lineChordPositions = [];

          chords.forEach((String off, String chord) {
            int chordPos = int.parse(off);
            if (chordPos >= offset && chordPos < endlineOffset)
              lineChordPositions.add(chordPos - offset);
          });
          bool isChord = !lineChordPositions.isEmpty;
          if (!lineChordPositions.contains(0)) {
            lineChordPositions.add(0);
          }
          lineChordPositions.sort((int a, int b) {
            return a > b ? 1 : (b > a ? -1 : 0);
          });

          var substrings = [];

          lineChordPositions.forEach((int chordPos) {
            int nextIndex = lineChordPositions.indexOf(chordPos) + 1;
            int substrEnd = (substrings.length + 1 < lineChordPositions.length) ? lineChordPositions.elementAt(nextIndex) : line.length;
            String substring = line.substring(chordPos, substrEnd);
            substrings.add({
                'offset': offset,
                'text': substring,
                'isChord': isChord,
                'hypen': (substrEnd < line.length && line[substrEnd - 1] != ' ' && line[substrEnd] != ' ')
            });
            offset += substring.length;
          });
          if (lines.isEmpty)
            chordOnFirstLine = isChord;
          lines.add(substrings);
        });

        sections.add({
            'title': title,
            'lines': lines,
            'padding': chordOnFirstLine
        });
      });
    }

    return sections;
  }
}