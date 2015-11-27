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
          'tag': tag.tag,
          'public': tag.public
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
          tags.add(new SongbookTag(data['tags'][i]['tag'], data['tags'][i]['public']));
        }
        return new Songbook(data['id'], data['name'], note: data['note'], public: data['public'],
                            username: data['username'], tags: tags, archived: data['archived'],
                            rating: data['rating'], numberOfSongs: data['songs']);
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
        tags.add(new SongbookTag(response.data['tags'][i]['tag'], response.data['tags'][i]['public']));
      }

      var songs = [];
      for(var j = 0; j < response.data['songs'].length; j++) {
        var songTags = [];
        for (var i = 0; i < response.data['songs'][j]['tags'].length; i++) {
          songTags.add(new SongTag(response.data['songs'][j]['tags'][i]['tag'], response.data['songs'][j]['tags'][i]['public']));
        }
        songs.add(new Song(response.data['songs'][j]['title'], response.data['songs'][j]['album'],
                          response.data['songs'][j]['author'], response.data['songs'][j]['year'],
                          response.data['songs'][j]['public'], username: response.data['songs'][j]['username'],
                          id: response.data['songs'][j]['id'], tags: songTags,
                          archived: response.data['songs'][j]['archived'],
                          posInSongbook: response.data['songs'][j]['position']));
      }
      songs.sort((Song a, Song b){ // tady neni sort potreba, ale urcite bude potreba pri zmene poradi
        if(a.posInSongbook > b.posInSongbook)
          return 1;
        if(b.posInSongbook > a.posInSongbook)
          return -1;
        return 0;
      });

      return new Songbook(response.data['id'], response.data['name'], note: response.data['note'],
                          public: response.data['public'], songs: songs,
                          username: response.data['username'], tags: tags, rating: response.data['rating']);
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