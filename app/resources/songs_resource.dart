part of app;

@Injectable()
class SongsResource {
  final Api _api;

  SongsResource(this._api);

  Future<List<Song>> readAll() {
    return _api.get('songs').then((HttpResponse response) {
      var songs = response.data.map((data) {
        return new Song(data['title'], data['album'], data['author'], data['originalAuthor'], data['year'], id: data['id']);
      });

      return new Future.value(songs);
    });
  }

  Future create(Song song) {
    _normalize(song);
    return _api.post('songs', data: {
        'title': song.title,
        'album': song.album,
        'author': song.author,
        'originalAuthor': song.originalAuthor,
        'year': song.year,
        'lyrics': song.lyrics,
        'chords': JSON.encode(song.chords)
    }).then((HttpResponse response) {
      song.id = response.data['id'];
      return new Future.value(song);
    });
  }

  Future update(Song song) {
    _normalize(song);
    return _api.put('songs/' + song.id.toString(), data: {
        'title': song.title,
        'album': song.album,
        'author': song.author,
        'originalAuthor': song.originalAuthor,
        'year': song.year,
        'lyrics': song.lyrics,
        'chords': JSON.encode(song.chords)
    }).then((HttpResponse response) {
      return new Future.value(song);
    });
  }

  Future<Song> read(int id) {
    return _api.get('songs/' + id.toString()).then((HttpResponse response) {
      var chords = JSON.decode(response.data['chords']);
      if (chords == null) {
        chords = {};
      }
      return new Song(response.data['title'], response.data['album'], response.data['author'], response.data['originalAuthor'], response.data['year'], lyrics: response.data['lyrics'], chords: chords, id: response.data['id']);
    });
  }

  void _normalize(Song song) {
    if (song.album == '') song.album = null;
    if (song.author == '') song.author = null;
    if (song.originalAuthor == '') song.originalAuthor = null;
    if (song.year == '') song.year = null;
  }

}