part of app;

@Injectable()
class SongbooksResource {
  final Api _api;

  SongbooksResource(this._api);

  /**
   * Creates new songbook.
   */
  Future create(Songbook songbook) {
    _normalize(songbook);
    return _api.post('songbooks', data: {
      'name': songbook.name,
      'note': songbook.note,
      'public': songbook.public
    }).then((HttpResponse response) {
      songbook.id = response.data['id'];
      return new Future.value(songbook);
    });
  }

  /**
   * Read's all songbooks.
   */
  Future<List<Songbook>> readAll([String search]) {
    return _api.get('songbooks', params: {'search': search}).then((HttpResponse response) {
      var songbooks = response.data.map((data) {
        return new Songbook(data['id'], data['name'], data['note'], data['public'], username: data['username']);
      });

      return new Future.value(songbooks);
    });
  }

  /**
   * Reads songbook by id.
   */
  Future<Songbook> read(int id) {
    return _api.get('songbooks/' + id.toString()).then((HttpResponse response) {
      return new Songbook(response.data['id'], response.data['name'], response.data['note'], response.data['public'], songs: response.data['songs'], username: response.data['username']);
    });
  }

  /**
   * Updates songbook.
   */
  Future edit(Songbook songbook) {
    _normalize(songbook);
    return _api.put('songbooks/' + songbook.id.toString(), data: {
      'name': songbook.name,
      'note': songbook.note,
      'public' : songbook.public
    }).then((_){

    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Songbook songbook) {
    if (songbook.note == '') songbook.note = null;
  }
}