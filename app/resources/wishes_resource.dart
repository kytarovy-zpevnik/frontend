part of app;

@Injectable()
class WishesResource {
  final Api _api;

  WishesResource(this._api);

  /**
   * Creates new wish.
   */
  Future create(Wish wish) {
    _normalize(wish);
    return _api.post('wishes', data: {
        'name': wish.name,
        'interpret': wish.interpret,
        'note': wish.note
    }).then((HttpResponse response) {
      wish.id = response.data['id'];
      return new Future.value(wish);
    });
  }

  /**
   * Read's all wishes.
   */
  Future<List<Wish>> readAll() {
    return _api.get('wishes').then((HttpResponse response) {
      var wishes = response.data.map((data) {
        return new Wish(id: data['id'], name: data['name'], interpret: data['interpret'], note: data['note'], created: data['created'], modified: data['modified']);
      });

      return new Future.value(wishes);
    });
  }

  /**
   * Reads wish by id.
   */
  Future<Wish> read(int id) {
    return _api.get('wishes/' + id.toString()).then((HttpResponse response) {
      return new Wish(id: response.data['id'], name: response.data['name'], interpret: response.data['interpret'], note: response.data['note'], created: response.data['created'], modified: response.data['modified']);
    });
  }

  /**
   * Updates wish by od.
   */
  Future edit(Wish wish) {
    _normalize(wish);
    return _api.put('wishes/' + wish.id.toString(), data: {
        'name': wish.name,
        'interpret': wish.interpret,
        'note': wish.note
    }).then((_){
    });
  }

  /**
   * Deletes wish by id.
   */
  Future delete(Wish wish) {
    return _api.put('wishes/' + wish.id.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Wish wish) {
    if (wish.note == '') wish.note = null;
  }

}