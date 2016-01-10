part of app;

@Injectable()
class SongRatingResource {
  final Api _api;

  SongRatingResource(this._api);

  /**
   * Creates new song rating.
   */
  Future createRating( int songId, Rating rating) {
    _normalize(rating);
    return _api.post('songs/' + songId.toString()  + "/rating", data: {
        'comment': rating.comment,
        'rating': rating.rating
    }).then((HttpResponse response) {
      rating.id = response.data['id'];
      return new Future.value(rating);
    });
  }

  /**
   * Reads all song ratings.
   */
  Future<List<Rating>> readAllRating(int songId) {
    return _api.get('songs/' + songId.toString() + "/rating").then((HttpResponse response) {
      var ratings = response.data.map((data) {
        return new Rating(id: data['id'], comment: data['comment'], rating: data['rating'], created: data['created'], modified: data['modified'], userId: data['user']);
      });

      return new Future.value(ratings);
    });
  }

  /**
   * Updates song rating by id.
   */
  Future updateRating(int id, Rating rating) {
    _normalize(rating);
    int ratingId = rating.id;
    return _api.put('songs/' + id.toString()  + "/rating/" + ratingId.toString()  , data: {
        'comment': rating.comment,
        'rating': rating.rating
    }).then((_){
    });
  }

  /**
   * Deletes song rating by id.
   */
  Future deleteRating(int songId, Rating rating) {
    return _api.delete('songs/' + songId.toString()  + '/rating/' + rating.id.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Rating rating) {
  }

}