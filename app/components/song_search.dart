part of app;

@Component(
    selector: 'song_search',
    templateUrl: 'html/templates/song_search.html',
    cssUrl: 'css/bootstrap.min.css',
    publishAs: 'cmp')
class SongSearch {
  @NgOneWay('visible')
  bool visible = false;

  @NgTwoWay('ctrl')
  SongsController ctrl;

  @NgTwoWay('filters')
  Map<String,String> filters;

  String _title;
  String _album;
  String _author;
  String _tag;

  get title => _title;
  set title(String title) {
    if(title == null || title == '')
      filters.remove('title');
    else
      filters['title'] = title.trim();
    _title = title;
  }

  get album => _album;
  set album(String album) {
    if(album == null || album == '')
      filters.remove('album');
    else
      filters['album'] = album.trim();
    _album = album;
  }

  get author => _author;
  set author(String author) {
    if(author == null || author == '')
      filters.remove('author');
    else
      filters['author'] = author.trim();
    _author = author;
  }

  get tag => _tag;
  set tag(String tag) {
    if(tag == null || tag == '')
      filters.remove('tag');
    else
      filters['tag'] = tag.trim();
    _tag = tag;
  }

  SongSearch() {
  }
}
