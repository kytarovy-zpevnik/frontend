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

  int tab = 0;

  String radio = '0';

  List lyrics = [];

  List items = [];

  List<ChordPosition> chpos = [];

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
          print(rowOffset);
          title = section.substring(2, rowOffset) + ':';
          rowOffset += 2;
        } else {
          rowOffset = 0;
        }

        first = true;
        var lines = [];
        section.substring(rowOffset).trim().split('\n').forEach((String line) {
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
    _sessionService.initialized.then((_) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);

      if (create) {
        querySelector('html').classes.remove('wait');
        song = new Song('', '', '', '', '', '', false);

        if (_routeProvider.parameters.containsKey('songbookId')) {
          _songbooksResource.read(_routeProvider.parameters['songbookId']).then((Songbook songbook) {
            song.songbooks.add(songbook);
          });
        }

        _songbooksResource.readAll().then((List<Songbook> songbooks) {
          songbooks.forEach((Songbook songbook) {
            this.items.add({
              'songbook': songbook,
              'included': false
            });
          });
        });

      } else {
        _songsResource.read(_routeProvider.parameters['id']).then((Song song) {
          this.song = song;
          computeLyrics();
          querySelector('html').classes.remove('wait');

          _songbooksResource.readAll().then((List<Songbook> songbooks) {
            songbooks.forEach((Songbook songbook) {
              var included = false;

              song.songbooks.forEach((Songbook songsongbook) {
                if (songbook.id == songsongbook.id) {
                  included = true;
                }
              });

              this.items.add({
                'songbook': songbook,
                'included': included
              });
            });
          });
        });
      }

    }); // dodělat úplně všude a nejspíš roztáhnout na celou metodu
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
            offset += currLine.length + 2;
            this.song.lyrics += currLine + '\n\n';
            curr += 2;
            next += 2;
          }
          else if(!nextLine.startsWith(' ')){ // second line doesn't start with space -> first must be lyrics
            offset += currLine.length + 1;
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
            if(failed){
              offset += currLine.length + 1;
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
      int chordPos;
      int chordEnd;
      while((chordPos = _textExport.indexOf('[', prev)) != -1){
        if((chordEnd = _textExport.indexOf(']', prev)) == -1)
          break;
        this.song.lyrics += _textExport.substring(prev, chordPos);
        this.song.chords[(chordPos-chordsLen).toString()] = _textExport.substring(chordPos + 1, chordEnd);
        prev = chordEnd + 1;
        chordsLen += (chordEnd - chordPos + 1);
      }
      this.song.lyrics += _textExport.substring(prev, _textExport.length);
    }
  }

  void export(String type) {
    if(type == 'agama'){
      /*_songsResource.export(_routeProvider.parameters['id']).then((String agama) {
        this.agama = agama;
      });*/
      _agama = '';
      List<String> sortedOffset = this.song.chords.keys.toList()..sort((String a, String b){
        int ai = int.parse(a);
        int bi = int.parse(b);
        if(ai > bi) return 1;
        else if(ai == bi) return 0;
        else return -1;
      });
      List<int> endlines = [];
      while(true){
        endlines.add(this.song.lyrics.indexOf('\n', endlines.isEmpty ? 0 : endlines.last+1));
        if(endlines.last == -1)
          break;
      }
      List<String> lines = this.song.lyrics.split('\n');
      int linesIndex = 0;
      int offIndex = 0;
      int sectionsLen = 0;
      while(linesIndex < lines.length){
        int offset, lastOffset = 0, numOfSPaces = 0;
        String chordLine = '';
        String lyricLine = '';
        String thisLine = lines.elementAt(linesIndex);

        if (thisLine.indexOf('((') == 0 && thisLine.indexOf('))') != -1) {
          sectionsLen += thisLine.indexOf('))') + 2;
        }

        while(offIndex < sortedOffset.length) {
          offset = int.parse(sortedOffset.elementAt(offIndex)) + sectionsLen;;
          if((endlines.elementAt(linesIndex) != -1 && offset >= endlines.elementAt(linesIndex)) || (endlines.elementAt(linesIndex) == -1 && offset >= this.song.lyrics.length))
            break;
          if (linesIndex != 0)
            offset -= (endlines.elementAt(linesIndex - 1) + 1);
          String chord = this.song.chords[(sortedOffset.elementAt(offIndex))];
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
      List sortedOffset = this.song.chords.keys.toList()..sort((String a, String b){
        int ai = int.parse(a);
        int bi = int.parse(b);
        if(ai > bi) return 1;
        else if(ai == bi) return 0;
        else return -1;
      });
      sortedOffset.forEach((String offset){
        _textExport += this.song.lyrics.substring(last, (int.parse(offset) < this.song.lyrics.length ? int.parse(offset) : this.song.lyrics.length)) + '[' + this.song.chords[offset] + ']';
        last = int.parse(offset);
      });
      _textExport += this.song.lyrics.substring(last, this.song.lyrics.length);
    }
  }

  void transpose(int transposition) {
    transposition %= 12; // shift by 0-12 semitones
    _songsResource.read(_routeProvider.parameters['id'], transposition).then((Song song) {
      this.song = song;
      computeLyrics();
    });
  }

  void addToSongbook(int index) {
    items[index]['included'] = true;
    song.songbooks.add(items[index]['songbook']);
    _songsResource.update(song).then((_){
      _messageService.showSuccess("Přidána", "Písnička byla úspěšně přidána do zpěvníku.");
      _router.go('songs.view', {'id': song.id});
    });
  }

  void removeFromSongbook(int index) {
    items[index]['included'] = false;

    var toRemove;
    song.songbooks.forEach((songbook) {
      if (songbook.id == items[index]['songbook'].id) {
        toRemove = songbook;
      }
    });

    song.songbooks.remove(toRemove);
    _songsResource.update(song).then((_){
      _messageService.showSuccess('Odebrána','Píseň byla úspěšně odebrána ze zpěvníku.');
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

}