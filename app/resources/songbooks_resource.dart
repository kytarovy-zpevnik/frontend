part of app;

@Injectable()
class SongbooksResource {
  final Api _api;

  SongbooksResource(this._api);

  Future create(Songbook songbook) {
    _normalize(songbook);
    return _api.post('songbooks', data: {
      'name': songbook.name
    }).then((HttpResponse response) {
      songbook.id = response.data['id'];
      return new Future.value(songbook);
    });
  }

  Future<List<Songbook>> readAll([String search]) {
    return _api.get('songbooks', params: {'search': search}).then((HttpResponse response) {
      var songbooks = response.data.map((data) {
        return new Songbook(data['id'], data['name']);
      });

      return new Future.value(songbooks);
    });
  }

  Future<Songbook> read(int id) {
    return _api.get('songbooks/' + id.toString()).then((HttpResponse response) {
      return new Songbook(response.data['id'], response.data['name'], songs: response.data['songs']);
    });
  }

  Future edit(Songbook songbook) {
    _normalize(songbook);
    return _api.put('songbooks/' + songbook.id.toString(), data: {
      "name": songbook.name
    }).then((_){

    });
  }

  void _normalize(Songbook songbook) {
    //nothing to normalize for now
  }
}