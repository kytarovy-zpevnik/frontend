part of app;

@Injectable()
class SongbookRatingResource {
  final Api _api;

  SongbookRatingResource(this._api);

  /**
   * Creates new songbook rating.
   */
  Future createRating(Rating rating, int songbookId) {
    _normalize(rating);
    return _api.post('songbooks' + songbookId.toString(), data: {
        'comment': rating.comment,
        'rating': rating.rating
    }).then((HttpResponse response) {
      rating.id = response.data['id'];
      return new Future.value(rating);
    });
  }

  /**
   * Reads all songbook ratings.
   */
  Future<List<Rating>> readAllRating(int songbookId) {
    return _api.get('songbooks'  + songbookId.toString()).then((HttpResponse response) {
      var ratings = response.data.map((data) {
        return new Rating(id: data['id'], comment: data['comment'], created: data['created'], modified: data['modified']);
      });

      return new Future.value(ratings);
    });
  }

  /**
   * Reads songbook rating by id.
   */
  Future<Rating> readRating(int id) {
    return _api.get('songbooks/' + id.toString()).then((HttpResponse response) {
      return new Rating(id: response.data['id'], comment: response.data['comment'], rating: response.data['rating'], created: response.data['created'], modified: response.data['modified']);
    });
  }

  /**
   * Updates songbook rating by id.
   */
  Future editRating(Rating rating) {
    _normalize(rating);
    return _api.put('songbooks/' + rating.id.toString(), data: {
        'comment': rating.comment,
        'rating': rating.rati,
    }).then((_){
    });
  }

  /**
   * Deletes songbook rating by id.
   */
  Future deleteRating(Rating rating) {
    return _api.put('songbooks/' + rating.id.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Rating rating) {
  }

}