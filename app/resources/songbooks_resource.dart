part of app;

@Injectable()
class SongbooksResource {
  final Api _api;

  SongbooksResource(this._api);


  Future<List<Songbook>> readAll() {
    return _api.get('songbooks').then((HttpResponse response) {
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

}