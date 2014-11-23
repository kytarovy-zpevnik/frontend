part of app;

@Injectable()
class SongbookSharingResource {
  final Api _api;

  SongbookSharingResource(this._api);

  /**
   * Creates new songbook sharing.
   */
  Future create( int songbookId, int userId, bool editable) {
    return _api.post('songbooks/' + songbookId.toString()  + "/sharing", data: {
        'user': userId,
        'editable': editable
    }).then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

}