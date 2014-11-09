part of app;

@Injectable()
class SongbookRatingResource {
  final Api _api;

  SongbookRatingResource(this._api);

  /**
   * Creates new songbook rating.
   */
  Future createRating( int songbookId, Rating rating) {
    _normalize(rating);
    return _api.post('songbooks/' + songbookId.toString()  + "/rating", data: {
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
    return _api.get('songbooks/' + songbookId.toString() + "/rating").then((HttpResponse response) {
      var ratings = response.data.map((data) {
        return new Rating(id: data['id'], comment: data['comment'], rating: data['rating'], created: data['created'], modified: data['modified']);
      });

      return new Future.value(ratings);
    });
  }

  /**
   * Reads songbook rating by id.
   */
  Future<Rating> readRating(int songbookId, int id) {
    return _api.get('songbooks/' + songbookId.toString()  + "/rating" + id.toString()).then((HttpResponse response) {
      return new Rating(id: response.data['id'], comment: response.data['comment'], rating: response.data['rating'], created: response.data['created'], modified: response.data['modified']);
    });
  }

  /**
   * Reads songbook rating by id.
   */
  Future<Rating> editAllRating(int songbookId) {
    return _api.get('songbooks/' + songbookId.toString() + "/rating").then((HttpResponse response) {
      if (response.data['message'] == "content") {
        return response.data['id'];
      }
      return 0;
    });
  }

  /**
   * Updates songbook rating by id.
   */
  Future editRating(int songbookId, Rating rating) {
    _normalize(rating);
    return _api.put('songbooks/' + songbookId.toString()  + "/rating" + rating.id.toString()  , data: {
        'comment': rating.comment,
        'rating': rating.rating
    }).then((_){
    });
  }

  /**
   * Deletes songbook rating by id.
   */
  Future deleteRating(int songbookId, Rating rating) {
    return _api.put('songbooks/' + songbookId.toString()  + '/rating' + rating.id.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Rating rating) {
  }

}