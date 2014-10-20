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


}