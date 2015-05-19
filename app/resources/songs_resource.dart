part of app;

@Injectable()
class SongsResource {
  final Api _api;

  SongsResource(this._api);

  /**
   * Creates new song.
   */
  Future create(Song song) {
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
          'public': true
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
      print(song.id);
      return new Future.value(song);
    });
  }

  /**
   * Read's all songs.
   */
  Future<List<Song>> readAll({bool admin, bool randomPublic, String searchPublic, String search, Map<String, String> filters}) {
    var params;
    if (filters != null) {
      params = filters;
    }
    else if (search != null) {
      params = {'search': search};
    }
    else if(randomPublic != null){
        params = {'randomPublic': randomPublic};
      }
      else if(admin != null){
          params = {'admin': admin};
        }
        else {
          if(searchPublic == '')
            searchPublic = ' ';
          params = {'searchPublic': searchPublic};
        }
    return _api.get('songs', params: params).then((HttpResponse response) {
      var songs = response.data.map((data) {
        var tags = [];
        for (var i = 0; i < data['tags'].length; i++) {
          tags.add(new SongTag(data['tags'][i]['tag'], data['tags'][i]['public']));
        }
        return new Song(data['title'], data['album'], data['author'], data['originalAuthor'], data['year'], data['note'], data['public'], id: data['id'], username: data['username'], tags: tags, archived: data['archived']);
      });

      return new Future.value(songs);
    });
  }

  /**
   * Reads song by id.
   */
  Future<Song> read(int id, [int transposition]) {
    var url;
    if (transposition == null) {
      url = 'songs/' + id.toString();
    } else {
      url = 'songs/' + id.toString() + '?transpose=' + transposition.toString();
    }
    return _api.get(url).then((HttpResponse response) {
      var chords = JSON.decode(response.data['chords']);
      if (chords == null) {
        chords = {
        };
      }
      var songbooks = [];
      for (var i = 0; i < response.data['songbooks'].length; i++) {
        songbooks.add(new Songbook(response.data['songbooks'][i]['id'], response.data['songbooks'][i]['name'], response.data['songbooks'][i]['note'], public: response.data['songbooks'][i]['public']));
      }
      var tags = [];
      for (var i = 0; i < response.data['tags'].length; i++) {
        tags.add(new SongTag(response.data['tags'][i]['tag'], response.data['tags'][i]['public']));
      }
      return new Song(response.data['title'], response.data['album'], response.data['author'], response.data['originalAuthor'], response.data['year'], response.data['note'], response.data['public'], lyrics: response.data['lyrics'], chords: chords, id: response.data['id'], username: response.data['username'], songbooks: songbooks, tags: tags);
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
    return _api.delete('songs/' + song.id.toString()).then((_){
    });
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
   * Creates new song which is taken from other user.
   */
  Future takeSong(Song song) {
    _normalize(song);

    var songbooks = [];

    var tags = [];
    song.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag
      });
    });

    var params;
    params = {'takenFrom': song.id};

    return _api.post('songs', params: params, data: {
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
      print(song.id);
      return new Future.value(song);
    });
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