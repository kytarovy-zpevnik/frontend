part of app;

@Injectable()
class SongbookCommentsResource {
  final Api _api;

  SongbookCommentsResource(this._api);

  /**
   * Creates new songbook comment.
   */
  Future createComment( int songbookId, Comment comment) {
    _normalize(comment);
    return _api.post('songbooks/' + songbookId.toString()  + "/comment", data: {
        'comment': comment.comment,
    }).then((HttpResponse response) {
      comment.id = response.data['id'];
      return new Future.value(comment);
    });
  }

  /**
   * Reads all songbook comments.
   */
  Future<List<Comment>> readAllComments(int songbookId) {
    return _api.get('songbooks/' + songbookId.toString() + "/comment").then((HttpResponse response) {
      var comments = response.data.map((data) {
        return new Comment(id: data['id'], comment: data['comment'], created: DateTime.parse(data['created']),
                            modified: DateTime.parse(data['modified']), username: data['username']);
      });

      return new Future.value(comments);
    });
  }

  /**
   * Reads songbook comment by id.
   */
  Future<Comment> readComment(int id, int commentId) {
    return _api.get('songbooks/' + id.toString()  + "/comment/" + commentId.toString()).then((HttpResponse response) {
      return new Comment(id: response.data['id'], comment: response.data['comment'],
                          created: DateTime.parse(response.data['created']),
                          modified: DateTime.parse(response.data['modified']),
                          username: response.data['username']);
    });
  }

  /**
   * Updates songbook comment by id.
   */
  Future updateComment(int id, Comment comment) {
    _normalize(comment);
    return _api.put('songbooks/' + id.toString()  + "/comment/" + comment.id.toString(), data: {
        'comment': comment.comment,
    }).then((_){
    });
  }

  /**
   * Deletes songbook comment by id.
   */
  Future deleteComment(int songbookId, int commentId) {
    return _api.delete('songbooks/' + songbookId.toString()  + '/comment/' + commentId.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Comment comment) {
  }

}