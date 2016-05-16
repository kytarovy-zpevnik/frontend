part of app;

@Injectable()
class SongbooksResource {
  final Api _api;

  SongbooksResource(this._api);

  /**
   * Creates new songbook.
   */
  Future create(Songbook songbook, {bool copy}) {
    _normalize(songbook);

    var songs = [];
    songbook.songs.forEach((song) {
      songs.add({
          'id': song.id
      });
    });

    var tags = [];
    songbook.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag,
          'public': tag.public
      });
    });

    return _api.post('songbooks', data: {
        'name': songbook.name,
        'note': songbook.note,
        'public': songbook.public,
        'songs': songs,
        'tags': tags
    }).then((HttpResponse response) {
      songbook.id = response.data['id'];
      return new Future.value(songbook);
    });
  }

  /**
   * Reads all songbooks.
   */
  Future<List<Songbook>> readAll(int offset, String sort, String order, {bool public, bool admin, bool random, String search, Map<String, String> filters, bool justOwned}) {
    Map params = {'length': 20};
    params.addAll({'offset': offset, 'sort': sort, 'order': order});

    if (public != null) {
      params.addAll({'public': public});
    }
    if (admin != null) {
      params.addAll({'admin': admin});
    }
    else if(random != null){
      params.addAll({'random': random});
    }
    else if (search != null) {
      params.addAll({'search': search});
    }
    else if (filters != null) {
      params.addAll(filters);
    }

    if (justOwned != null) {
      params.addAll({'justOwned': justOwned});
    }

    return _api.get('songbooks', params: params).then((HttpResponse response) {
      var songbooks = response.data.map((data) {
        var tags = [];
        for (var i = 0; i < data['tags'].length; i++) {
          tags.add(new Tag(data['tags'][i]['tag'], data['tags'][i]['public']));
        }
        return new Songbook(data['id'], data['name'], note: data['note'], public: data['public'],
                            username: data['username'], tags: tags, archived: data['archived'],
                            numberOfSongs: data['songs'], rating: data['rating']['rating'],
                            numOfRating: data['rating']['numOfRating']);
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
        tags.add(new Tag(response.data['tags'][i]['tag'], response.data['tags'][i]['public']));
      }

      var songs = [];
      for(var j = 0; j < response.data['songs'].length; j++) {
        var songTags = [];
        for (var i = 0; i < response.data['songs'][j]['tags'].length; i++) {
          songTags.add(new Tag(response.data['songs'][j]['tags'][i]['tag'], response.data['songs'][j]['tags'][i]['public']));
        }
        songs.add(new Song(response.data['songs'][j]['title'], response.data['songs'][j]['album'],
                          response.data['songs'][j]['author'], response.data['songs'][j]['year'],
                          response.data['songs'][j]['public'], username: response.data['songs'][j]['username'],
                          id: response.data['songs'][j]['id'], tags: songTags,
                          archived: response.data['songs'][j]['archived'],
                          posInSongbook: response.data['songs'][j]['position']));
      }

      return new Songbook(response.data['id'], response.data['name'], note: response.data['note'],
                          public: response.data['public'], songs: songs, tags: tags,
                          username: response.data['username'], rating: response.data['rating']['rating'],
                          numOfRating: response.data['rating']['numOfRating'], taken: response.data['taken']);
    });
  }

  /**
   * Updates songbook.
   */
  Future update(Songbook songbook, [String action]) {
    _normalize(songbook);
    var params;

    if(action != null){
      params = {'action': action};
    }

    var songs = [];
    songbook.songs.forEach((song) {
      songs.add({
          'id': song.id
      });
    });

    var tags = [];
    songbook.tags.forEach((tag) {
      tags.add({
          'tag': tag.tag,
          'public': tag.public
      });
    });

    return _api.put('songbooks/' + songbook.id.toString(), data: {
      'name': songbook.name,
      'note': songbook.note,
      'public' : songbook.public,
      'songs': songs,
      'tags': tags
    }, params: params).then((HttpResponse response) {
      return new Future.value(songbook);
    });
  }

  /**
   * Deletes songbook by id.
   */
  Future delete(Songbook songbook) {
    return _api.delete('songbooks/' + songbook.id.toString());
  }

  /**
   * Enables given user access to private songbook.
   */
  Future shareSongbook(int songbookId, String user) {
    return _api.post('songbooks/' + songbookId.toString()  + "/sharing", data: {
        'user': user
    }).then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

  /**
   * Creates new songbook as a copy of given songbook.
   * */
  Future copySongbook(Songbook songbook) {
    return _api.post('songbooks/' + songbook.id.toString()  + "/copy").then((HttpResponse response) {
      songbook.id = response.data['id'];
      return new Future.value(songbook);
    });
  }

  /**
   * Enables active user tagging songbook owned by someone else.
   */
  Future takeSongbook(Songbook songbook) { // bude změněno
    return _api.post('songbooks/' + songbook.id.toString()  + "/taking").then((HttpResponse response) {
      return new Future.value(response.data['id']);
    });
  }

  /**
   * Cancel taking made by takeSongbook method
   */
  Future untakeSongbook(Songbook songbook) {
    return _api.delete('songbooks/' + songbook.id.toString()  + "/taking");
  }

  /**
   * Sets empty values to null.
   */
  void _normalize(Songbook songbook) {
    if (songbook.note == '') songbook.note = null;
  }
}