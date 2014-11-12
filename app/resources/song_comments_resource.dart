part of app;

@Injectable()
class SongCommentsResource {
  final Api _api;

  SongCommentsResource(this._api);

  /**
   * Creates new song comment.
   */
  Future createComment( int songId, Comment comment) {
    _normalize(comment);
    return _api.post('songs/' + songId.toString()  + "/comment", data: {
        'comment': comment.comment,
    }).then((HttpResponse response) {
      comment.id = response.data['id'];
      return new Future.value(comment);
    });
  }

  /**
   * Reads all song comments.
   */
  Future<List<Comment>> readAllComments(int songId) {
    return _api.get('songs/' + songId.toString() + "/comment").then((HttpResponse response) {
      var comments = response.data.map((data) {
        return new Comment(id: data['id'], comment: data['comment'], created: data['created'], modified: data['modified'], username: data['username']);
      });

      return new Future.value(comments);
    });
  }

  /**
   * Reads song comment by id.
   */
  Future<Comment> readComment(int id, int commentId) {
    return _api.get('songs/' + id.toString()  + "/comment/" + commentId.toString()).then((HttpResponse response) {
      return new Comment(id: response.data['id'], comment: response.data['comment'], created: response.data['created'], modified: response.data['modified'], username: response.data['username']);
    });
  }

  /**
   * Updates song comment by id.
   */
  Future editComment(int id, Comment comment) {
    _normalize(comment);
    return _api.put('songs/' + id.toString()  + "/comment/" + comment.id.toString(), data: {
        'comment': comment.comment,
    }).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Comment comment) {
  }

}