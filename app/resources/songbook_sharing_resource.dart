part of app;

@Injectable()
class SongbookSharingResource {
  final Api _api;

  SongbookSharingResource(this._api);

  /**
   * Creates new songbook sharing.
   */
  Future create( int songbookId, int userId) {
    return _api.post('songbooks/' + songbookId.toString()  + "/sharing", data: {
        'user': userId
    }).then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

}