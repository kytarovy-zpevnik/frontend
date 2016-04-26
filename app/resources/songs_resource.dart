part of app;

@Injectable()
class SongsResource {
  final Api _api;

  SongsResource(this._api);

  /**
   * Creates new song.
   */
  Future create(Song song, {bool copy}) {
    _normalize(song);

    var songbooks = [];
    song.songbooks.forEach((songbook) {
      songbooks.add({
          'id': songbook.id
      });
    });

    var tags = [];
    song.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag,
          'public': tag.public
      });
    });

    return _api.post('songs', data: {
        'title': song.title,
        'album': song.album,
        'author': song.author,
        'originalAuthor': song.originalAuthor,
        'year': song.year,
        'note': song.note,
        'public': song.public,
        'lyrics': song.lyrics,
        'chords': JSON.encode(song.chords),
        'songbooks': songbooks,
        'tags': tags
    }).then((HttpResponse response) {
      song.id = response.data['id'];
      return new Future.value(song);
    });
  }

  /**
   * Read's all songs.
   */
  Future<List<Song>> readAll(int offset, String sort, String order, {bool public, bool admin, bool random, String search, Map<String, String> filters}) {
    Map params = {'length': 20};
      params.addAll({'offset': offset, 'sort': sort, 'order': order});

    if (public != null) {
      params.addAll({'public': public});
    }
    if (admin != null) {
      params.addAll({'admin': admin});
    }
    else if(random != null){
      params.addAll({'random': random});
    }
    else if (search != null) {
      params.addAll({'search': search});
    }
    else if (filters != null) {
      params.addAll(filters);
    }

    return _api.get('songs', params: params).then((HttpResponse response) {
      var songs = response.data.map((data) {
        var tags = [];
        for (var i = 0; i < data['tags'].length; i++) {
          tags.add(new SongTag(data['tags'][i]['tag'], data['tags'][i]['public']));
        }
        return new Song(data['title'], data['album'], data['author'], data['year'],
                        data['public'], id: data['id'], username: data['username'],
                        tags: tags, archived: data['archived'], rating: data['rating']['rating'],
                        numOfRating: data['rating']['numOfRating']);
      });

      return new Future.value(songs);
    });
  }

  /**
   * Reads song by id.
   */
  Future<Song> read(int id, {bool old}) {
    var params = {};
    if(old){
      params = {'old': old};
    }
    return _api.get('songs/' + id.toString(), params: params).then((HttpResponse response) {
      var chords = JSON.decode(response.data['chords']);
      if (chords == null) {
        chords = {
        };
      }
      var songbooks = [];
      for (var i = 0; i < response.data['songbooks'].length; i++) {
        songbooks.add(new Songbook(response.data['songbooks'][i]['id'], response.data['songbooks'][i]['name'], note: response.data['songbooks'][i]['note'], public: response.data['songbooks'][i]['public']));
      }
      var tags = [];
      for (var i = 0; i < response.data['tags'].length; i++) {
        tags.add(new SongTag(response.data['tags'][i]['tag'], response.data['tags'][i]['public']));
      }
      return new Song(response.data['title'], response.data['album'], response.data['author'], response.data['year'],
                      response.data['public'], originalAuthor: response.data['originalAuthor'], note: response.data['note'],
                      lyrics: response.data['lyrics'], chords: chords, id: response.data['id'],
                      username: response.data['username'], songbooks: songbooks,
                      tags: tags, archived: response.data['archived'], rating: response.data['rating']['rating'],
                      numOfRating: response.data['rating']['numOfRating'], old: old,
                      taken: response.data['taking']['taken'], copy: response.data['taking']['copy']);
    });
  }

  /**
   * Updates song.
   */
  Future update(Song song, [String action]) {
    _normalize(song);
    var params;

    if(action != null){
      params = {'action': action};
    }

    var songbooks = [];
    song.songbooks.forEach((songbook) {
      songbooks.add({
          'id': songbook.id
      });
    });

    var tags = [];
    song.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag,
          'public': tag.public
      });
    });

    return _api.put('songs/' + song.id.toString(), data: {
        'title': song.title,
        'album': song.album,
        'author': song.author,
        'originalAuthor': song.originalAuthor,
        'year': song.year,
        'note': song.note,
        'public': song.public,
        'lyrics': song.lyrics,
        'chords': JSON.encode(song.chords),
        'songbooks': songbooks,
        'tags': tags
    }, params: params).then((HttpResponse response) {
      return new Future.value(song);
    });
  }

  /**
   * Deletes song by id.
   */
  Future delete(Song song) {
    return _api.delete('songs/' + song.id.toString());
  }

  /**
   * Imports new song.
   */
  // XML IMPORT
  /*Future import(Song song, String agama) {
    _normalize(song);

    var songbooks = [];
    song.songbooks.forEach((songbook) {
      songbooks.add({
          'id': songbook.id
      });
    });

    var tags = [];
    song.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag
      });
    });

    return _api.post('songs?import=agama', data: {
        'title': song.title,
        'album': song.album,
        'author': song.author,
        'originalAuthor': song.originalAuthor,
        'year': song.year,
        'note': song.note,
        'public': song.public,
        'agama': agama,
        'songbooks': songbooks,
        'tags': tags
    }).then((HttpResponse response) {
      song.id = response.data['id'];
      print(song.id);
      return new Future.value(song);
    });
  }*/

  /**
   * Enables given user access to private song.
   */
  Future shareSong(int songId, String user) {
    return _api.post('songs/' + songId.toString()  + "/sharing", data: {
        'user': user
    }).then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

  /**
   * Creates new song as a copy of given song.
   * */
  Future copySong(Song song) {
    return _api.post('songs/' + song.id.toString()  + "/copy").then((HttpResponse response) {
      song.id = response.data['id'];
      return new Future.value(song);
    });
  }

  /**
   * Enables active user tagging song owned by someone else and adding it to own songbooks.
   */
  Future takeSong(Song song) {
    return _api.post('songs/' + song.id.toString()  + "/taking").then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

  /**
   * Cancel taking made by takeSong method
   */
  Future untakeSong(Song song) {
    return _api.delete('songs/' + song.id.toString()  + "/taking");
  }

  /**
   * Discard copy made when owner updated taken song
   */
  Future discardCopy(Song song) {
    return _api.put('songs/' + song.id.toString()  + "/taking");
  }

  /**
   * Exports song by id.
   */
  // XML EXPORT
  /*Future<String> export(int id) {
    return _api.get('songs/' + id.toString() + '?export=agama').then((HttpResponse response) {
      return response.data['agama'];
    });
  }*/

  /**
   * Sets empty values to null.
   */
  void _normalize(Song song) {
    if (song.album == '') song.album = null;
    if (song.author == '') song.author = null;
    if (song.originalAuthor == '') song.originalAuthor = null;
    if (song.year == '') song.year = null;
    if (song.note == '') song.note = null;
  }

}