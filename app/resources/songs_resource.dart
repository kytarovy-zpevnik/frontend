part of app;

@Injectable()
class SongsResource {
  final Api _api;

  SongsResource(this._api);


  Future<List<Song>> readAll() {
    return _api.get('songs').then((HttpResponse response) {
      var songs = response.data.map((data) {
        return new Song(data['id'], data['title'], data['album'], data['author'], data['originalAuthor'], data['year']);
      });

      return new Future.value(songs);
    });
  }


}