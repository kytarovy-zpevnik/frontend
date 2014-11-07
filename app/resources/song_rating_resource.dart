part of app;

@Injectable()
class SongRatingResource {
  final Api _api;

  SongRatingResource(this._api);

  /**
   * Creates new song rating.
   */
  Future createRating(Rating rating, int songId) {
    _normalize(rating);
    return _api.post('songs' + songId.toString(), data: {
        'comment': song.comment,
        'rating': song.rating
    }).then((HttpResponse response) {
      rating.id = response.data['id'];
      return new Future.value(rating);
    });
  }

  /**
   * Reads all song ratings.
   */
  Future<List<Rating>> readAllRating(int songId) {
    return _api.get('songs'  + songId.toString()).then((HttpResponse response) {
      var ratings = response.data.map((data) {
        return new Rating(id: data['id'], comment: data['comment'], created: data['created'], modified: data['modified']);
      });

      return new Future.value(ratings);
    });
  }

  /**
   * Reads song rating by id.
   */
  Future<Rating> readRating(int id) {
    return _api.get('songs/' + id.toString()).then((HttpResponse response) {
      return new Rating(id: response.data['id'], comment: response.data['comment'], rating: response.data['rating'], created: response.data['created'], modified: response.data['modified']);
    });
  }

  /**
   * Updates song rating by id.
   */
  Future editRating(Rating rating) {
    _normalize(rating);
    return _api.put('songs/' + rating.id.toString(), data: {
        'comment': rating.comment,
        'rating': rating.rati,
    }).then((_){
    });
  }

  /**
   * Deletes song rating by id.
   */
  Future deleteRating(Rating rating) {
    return _api.put('songs/' + rating.id.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Rating rating) {
  }

}