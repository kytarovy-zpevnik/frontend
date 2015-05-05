part of app;

@Injectable()
class SongbooksResource {
  final Api _api;

  SongbooksResource(this._api);

  /**
   * Creates new songbook.
   */
  Future create(Songbook songbook) {
    _normalize(songbook);

    var tags = [];
    songbook.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag
      });
    });

    return _api.post('songbooks', data: {
      'name': songbook.name,
      'note': songbook.note,
      'public': songbook.public,
      'tags': tags
    }).then((HttpResponse response) {
      songbook.id = response.data['id'];
      return new Future.value(songbook);
    });
  }

  /**
   * Reads all songbooks.
   */
  Future<List<Songbook>> readAll({bool admin, bool randomPublic, String searchPublic, String search}) {
    var params;
    if (search != null) {
      params = {'search': search};
    }
    /*else if (searchAllPublic != null) {
      params = {'searchAllPublic': searchAllPublic};
    }*/
    else if(randomPublic != null){
        params = {'randomPublic': randomPublic};
    }
    else if(admin != null){
      params = {'admin': admin};
    }
    else {
      if(searchPublic == '')
        searchPublic = ' ';
      params = {'searchPublic': searchPublic};
    }
    return _api.get('songbooks', params: params).then((HttpResponse response) {
      var songbooks = response.data.map((data) {
        var tags = [];
        for (var i = 0; i < data['tags'].length; i++) {
          tags.add(new SongbookTag(data['tags'][i]['tag']));
        }
        return new Songbook(data['id'], data['name'], data['note'], public: data['public'], username: data['username'], tags: tags, archived: data['archived']);
      });

      return new Future.value(songbooks);
    });
  }

  /**
   * Reads songbook by id.
   */
  Future<Songbook> read(int id) {
    return _api.get('songbooks/' + id.toString()).then((HttpResponse response) {
      var tags = [];
      for (var i = 0; i < response.data['tags'].length; i++) {
        tags.add(new SongbookTag(response.data['tags'][i]['tag']));
      }
      return new Songbook(response.data['id'], response.data['name'], response.data['note'], public: response.data['public'], songs: response.data['songs'], username: response.data['username'], tags: tags);
    });
  }

  /**
   * Updates songbook.
   */
  Future update(Songbook songbook) {
    _normalize(songbook);

    var tags = [];
    songbook.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag
      });
    });

    return _api.put('songbooks/' + songbook.id.toString(), data: {
      'name': songbook.name,
      'note': songbook.note,
      'public' : songbook.public,
      'tags': tags
    }).then((_){

    });
  }

  /**
   * Deletes songbook by id.
   */
  Future delete(Songbook songbook) {
    return _api.delete('songbooks/' + songbook.id.toString()).then((_){
    });
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Songbook songbook) {
    if (songbook.note == '') songbook.note = null;
  }
}