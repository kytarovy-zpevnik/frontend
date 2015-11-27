part of app;

@Controller(selector: '[song]', publishAs: 'ctrl')
class SongController {
  final SongsResource _songsResource;
  final SongbooksResource _songbooksResource;
  final MessageService _messageService;
  final SessionService _sessionService;
  final RouteProvider _routeProvider;
  final Router _router;

  Song song;

  User user;

  bool create;

  var createInSongbook = null;

  int tab = 0;

  String radio = '0';

  List lyrics = [];

  List allSongbooks = [];

  List<ChordPosition> chpos = [];

  int transposition = 0;

  String _agama;

  String get agama => _agama;

  set agama(String text) {
    _agama = text;
    this.import('agama');
  }

  String _textExport;

  String get textExport => _textExport;

  set textExport(String text) {
    _textExport = text;
    this.import('text');
  }

  void computeLyrics() {
    var offset = 0;

    var sections = [];

    if (song != null) {
      var first = true;
      song.lyrics.split('\n\n').forEach((String section) {
        if (first) {
          first = false;
        } else {
          offset += 2; // count in delimiting \n\n
        }
        var rowOffset = section.indexOf('))');
        var title = '';

        if (section.indexOf('((') == 0 && rowOffset != -1) {
          //print(rowOffset);
          title = section.substring(2, rowOffset) + ':';
          rowOffset += 2;
        } else {
          rowOffset = 0;
        }

        first = true;
        var lines = [];
        section.substring(rowOffset).split('\n').forEach((String line) {
          if (first) {
            first = false;
          } else {
            offset++;  // count in delimiting \n
          }
          var chars = [];
          line.split('').forEach((String char) {
            chars.add({
                'offset': offset++,
                'char': char
            });
          });
          lines.add(chars);
        });

        sections.add({
            'title': title,
            'lines': lines
        });
      });
    }

    lyrics = sections;
  }

  SongController(this._sessionService, this._songsResource, this._songbooksResource, this._messageService, this._routeProvider, this._router) {
    create = !_routeProvider.parameters.containsKey('id');

    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {  // analogicky u dalších controllerů
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){
    User currentUser = _sessionService.session.user;
    this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);

    if (create) {
      song = new Song('', '', '', '', false);
      querySelector('html').classes.remove('wait');

      if (_routeProvider.parameters.containsKey('songbookId')) {
        createInSongbook = _routeProvider.parameters['songbookId'];
        _songbooksResource.read(createInSongbook).then((Songbook songbook) {
          song.songbooks.add(songbook);
        });
      }

    } else {

      Future.wait([
          _songsResource.read(_routeProvider.parameters['id']).then((Song song) {
            this.song = song;
            computeLyrics();
          }),
          _songbooksResource.readAll().then((List<Songbook> songbooks) {
            //this.allSongbooks = songbooks;
            songbooks.forEach((Songbook songbook){
              this.allSongbooks.add(songbook);
            });
          })]
      ).then((List<Future> futures){
        querySelector('html').classes.remove('wait');
      });

    }
  }

  int _checkSection(String line){
    int sectionLen = 0;
    int right = line.indexOf('))');
    if(line.startsWith('((') && right != -1){
      sectionLen = right + 2;
    }
    return sectionLen;
  }

  void import(String type){
    this.song.lyrics = '';
    this.song.chords = {};
    int prev = 0, chordPos;

    if(type == 'agama'){
      List<String> lines = _agama.split('\n');
      int offset = 0;
      int curr = 0;
      int next = 1;
      while(curr < lines.length){
        String currLine = lines.elementAt(curr);
        if(next >= lines.length){
          this.song.lyrics += currLine;
          break;
        }
        if(currLine.isEmpty){
          offset += 1;
          this.song.lyrics += '\n';
          curr = next++;
          continue;
        }
        String nextLine = lines.elementAt(next);
        if(!currLine.startsWith(' ')){        // first line doesn't start with space
          if(nextLine.isEmpty){               // second line empty -> first must be lyrics, second "too"
            offset += currLine.length + 2 - _checkSection(currLine);
            this.song.lyrics += currLine + '\n\n';
            curr += 2;
            next += 2;
          }
          else if(!nextLine.startsWith(' ')){ // second line doesn't start with space -> first must be lyrics
            offset += currLine.length + 1 - _checkSection(currLine);
            this.song.lyrics += currLine + '\n';
            curr = next++;
          }
          else{                               // second line starts with space -> need to try, if first is chords
            String tmpLyrics = '';
            Map<int, String> tmpChords = {};
            int tmpOffset = offset;
            bool failed = false;
            prev = 0;
            while(true){
              chordPos = currLine.indexOf(new RegExp(r'[A-Z]'), prev);
              if(chordPos == -1){
                tmpLyrics += nextLine.substring(prev, nextLine.length);
                if(next != lines.length - 1)
                  tmpLyrics += '\n';
                tmpOffset += nextLine.substring(prev, nextLine.length).length + 1;
                break;
              }
              if(nextLine.substring(chordPos, chordPos+1) != ' '){
                failed = true;
                break;
              }
              String subline = nextLine.substring(prev, chordPos);
              if(chordPos > 0 && currLine.substring(chordPos-1, chordPos) != ' ')
                subline = subline.trimRight();
              tmpLyrics += subline;
              tmpOffset += subline.length;
              prev = chordPos + 1;
              int chordEnd = currLine.indexOf(new RegExp(r'[ A-Z]'), prev);
              tmpChords[(tmpOffset).toString()] = currLine.substring(chordPos, chordEnd > 0 ? chordEnd : currLine.length);
            }
            if(prev == 0)
              failed = true;
            if(failed){
              offset += currLine.length + 1 - _checkSection(currLine);
              this.song.lyrics += currLine + '\n';
              curr = next++;
            }
            else{
              this.song.lyrics += tmpLyrics;
              offset = tmpOffset;
              this.song.chords.addAll(tmpChords);
              curr += 2;
              next += 2;
            }
          }
        }
        else{                                 // first line starts with space -> must be chords
          prev = 0;
          offset -= _checkSection(nextLine);
          while(true){
            chordPos = nextLine.indexOf(' ', prev);
            if(chordPos == -1 || chordPos >= currLine.length){
              this.song.lyrics += nextLine.substring(prev, nextLine.length);
              if(next != lines.length - 1)
                this.song.lyrics += '\n';
              offset += nextLine.substring(prev, nextLine.length).length + 1;
              break;
            }
            this.song.lyrics += nextLine.substring(prev, chordPos);
            offset += nextLine.substring(prev, chordPos).length;
            prev = chordPos + 1;
            String possibleChord = currLine.substring(chordPos, prev);
            if(possibleChord == ' '){                               // no chord, just simple space
              this.song.lyrics += ' ';
              offset += 1;
            }
            else if(possibleChord == possibleChord.toUpperCase()){  // here is the beginning of chord - delete space and add chord
              int chordEnd = currLine.indexOf(new RegExp(r'[ A-Z]'), prev);
              this.song.chords[(offset).toString()] = currLine.substring(chordPos, chordEnd > 0 ? chordEnd : currLine.length);
            }
                                                                    // else there is the middle of chord - delete space (no action)
          }
          curr += 2;
          next += 2;
        }

      }
    }
    else{
      int prev = 0;
      int chordsLen = 0;
      int sectionsLen = 0;
      int chordPos;
      int chordEnd;
      while((chordPos = _textExport.indexOf('[', prev)) != -1){
        if((chordEnd = _textExport.indexOf(']', prev)) == -1)
          break;
        int left = _textExport.indexOf('((', prev);
        int right = _textExport.indexOf('))', prev);
        if(left != -1 && right != -1 && left < right && left <= chordPos && (left == 0 || left - 1 == _textExport.indexOf('\n'))){
          sectionsLen += right - left + 2;
        }
        this.song.lyrics += _textExport.substring(prev, chordPos);
        this.song.chords[(chordPos-chordsLen-sectionsLen).toString()] = _textExport.substring(chordPos + 1, chordEnd);
        prev = chordEnd + 1;
        chordsLen += (chordEnd - chordPos + 1);
      }
      this.song.lyrics += _textExport.substring(prev, _textExport.length);
    }
  }

  void export(String type) {
    List<String> sortedOffset = this.song.chords.keys.toList()..sort((String a, String b){
      int ai = int.parse(a);
      int bi = int.parse(b);
      if(ai > bi) return 1;
      else if(ai == bi) return 0;
      else return -1;
    }); // fill sorted list of chord offsets
    if(type == 'agama'){
      _agama = '';
      List<int> endlines = [];
      while(true){
        endlines.add(this.song.lyrics.indexOf('\n', endlines.isEmpty ? 0 : endlines.last+1));
        if(endlines.last == -1)
          break;
      } // fill list of indexes of endlines
      List<String> lines = this.song.lyrics.split('\n');  // fill list of lines from lyrics
      int linesIndex = 0; // iterating through lines
      int offIndex = 0;   // iterating through offsets
      int sectionsLen = 0;
      while(linesIndex < lines.length){
        int offset, lastOffset = 0, numOfSPaces = 0;
        String chordLine = '';
        String lyricLine = '';
        String thisLine = lines.elementAt(linesIndex);

        if (thisLine.indexOf('((') == 0 && thisLine.indexOf('))') != -1) {
          sectionsLen += thisLine.indexOf('))') + 2;    // increasing the sum of lengths of section delimiters
        }

        while(offIndex < sortedOffset.length) {
          offset = int.parse(sortedOffset.elementAt(offIndex)) + sectionsLen;   // actual offset is offset from the sorted list + sum of lengths of section delimiters
          if((endlines.elementAt(linesIndex) != -1 && offset >= endlines.elementAt(linesIndex)) || (endlines.elementAt(linesIndex) == -1 && offset >= this.song.lyrics.length))
            break;    // offset is not on this line
          if (linesIndex != 0)
            offset -= (endlines.elementAt(linesIndex - 1) + 1);   // decreasing offset by the length of lyrics
          String chord = this.song.chords[(sortedOffset.elementAt(offIndex))];
          if(offset < 0)
            offset = 0;
          int chPadding;
          if(offset + numOfSPaces < chordLine.length)
            chPadding = chord.length;
          else
            chPadding = offset - chordLine.length + chord.length + numOfSPaces;
          chordLine += chord.padLeft(chPadding);
          if (offset > 0)
            lyricLine += thisLine.substring(lastOffset, offset);
          int lPadding = chordLine.length + 1 - chord.length;
          numOfSPaces += lPadding - lyricLine.length;
          lyricLine = lyricLine.padRight(lPadding);
          lastOffset = offset;
          offIndex++;
        }

        if(chordLine != '')
          _agama += chordLine + '\n' + lyricLine;
        _agama += thisLine.substring(lastOffset, thisLine.length);
        if(endlines.elementAt(linesIndex) != -1)
          _agama += '\n';

        linesIndex++;
      }
    }
    else{
      _textExport = '';
      int last = 0;
      int sectionsLen = 0;
      sortedOffset.forEach((String offset){
        int newOffset = (int.parse(offset) < this.song.lyrics.length ? int.parse(offset) : this.song.lyrics.length) + sectionsLen;;
        int left = this.song.lyrics.indexOf('((', last);
        int right = this.song.lyrics.indexOf('))', last);
        if(left != -1 && right != -1 && left < right && left <= newOffset && (left == 0 || left - 1 == this.song.lyrics.indexOf('\n'))){
          sectionsLen += right - left + 2;
          newOffset += right - left + 2;
          // potrebuju zmenit offset o vsechny predchozi (())
        }
        _textExport += this.song.lyrics.substring(last, newOffset) + '[' + this.song.chords[offset] + ']';
        last = newOffset;
      });
      _textExport += this.song.lyrics.substring(last, this.song.lyrics.length);
    }
  }

  void transpose(int transposition) {
    this.transposition += transposition;
    this.transposition %= 12;

    String notePattern = 'C#|D#|F#|G#|C|D|E|F|G|A|B|H';
    List<String> chromaticScale = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'B', 'H'];

    this.song.chords.forEach((int k, String chord){

      this.song.chords[k] = chord.replaceAllMapped(new RegExp(notePattern), (Match match){
        int key = chromaticScale.indexOf(match.group(0));
        key += transposition;

        if(key >= chromaticScale.length)
          key -= chromaticScale.length;
        if(key < 0)
          key += chromaticScale.length;

        return chromaticScale[key];
      });

    });
    computeLyrics();
  }

  void addTags(){
    _songsResource.update(song, 'tags').then((_) {
      _messageService.prepareSuccess('Uloženo.', 'Tagy byly k písni úspěšně přidány.');
      _router.go('song.view', {'id': song.id});
    });
  }

  void addToSongbook(Songbook songbook) {
    song.songbooks.add(songbook);
  }

  void removeFromSongbook(Songbook songbook) {

    var toRemove;
    song.songbooks.forEach((songsongbook) {
      if (songsongbook.id == songbook.id) {
        toRemove = songsongbook;
      }
    });
    song.songbooks.remove(toRemove);
  }

  void saveSongbooks(){
    _songsResource.update(song).then((_){
      _messageService.showSuccess('Aktualizován','Seznam zpěvníků obsahujících tuto píseň byl úspěšně aktualizován.');
    });
  }

  void save() {
    if (create) {
      _songsResource.create(song).then((_) {
        _messageService.prepareSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
        _router.go('song.view', {
            'id': song.id
        });
      });
    } else {
      _songsResource.update(song).then((_) {
        _messageService.prepareSuccess('Uloženo.', 'Píseň byla úspěšně uložena.');
        _router.go('song.view', {'id': song.id});
      });
    }
  }

  void addChpos(ChordPosition chpos) {
    this.chpos.add(chpos);
  }

  void hideChordEditors() {
    this.chpos.forEach((chpos) {
      chpos.hideChordEditor();
    });
  }

  void takeSong() {
    _songsResource.takeSong(song).then((_) {
      _messageService.prepareSuccess('Vytvořeno.', 'Nová píseň byla úspěšně vytvořena.');
      _router.go('song.view', {'id': song.id});
    });
  }

  void delete(){
    _songsResource.delete(song).then((_){
      _messageService.prepareSuccess('Smazáno.', 'Píseň byla úspěšně smazána.');
      _router.go('songs', {});
    });
  }

}