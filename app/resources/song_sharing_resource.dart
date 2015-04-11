part of app;

@Injectable()
class SongSharingResource {
  final Api _api;

  SongSharingResource(this._api);

  /**
   * Creates new song sharing.
   */
  Future create( int songId, int userId) {
    return _api.post('songs/' + songId.toString()  + "/sharing", data: {
        'user': userId
    }).then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

}