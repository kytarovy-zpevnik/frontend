part of app;

/**
 * Filters model.
 */
class Filters {

  Map<String,String> filters = {};

  String _title;
  String _album;
  String _author;
  String _year;
  String _owner;
  String _tag;

  get title => _title;
  set title(String title) {
    _setFilter('title', title);
    _title = title;
  }

  get album => _album;
  set album(String album) {
    _setFilter('album', album);
    _album = album;
  }

  get author => _author;
  set author(String author) {
    _setFilter('author', author);
    _author = author;
  }

  get year => _year;
  set year(String year) {
    _setFilter('year', year);
    _year = year;
  }

  get owner => _owner;
  set owner(String owner) {
    _setFilter('owner', owner);
    _owner = owner;
  }

  get tag => _tag;
  set tag(String tag) {
    _setFilter('tag', tag);
    _tag = tag;
  }

  _setFilter(String filter, String value) {
    if(value == null || value == '')
      filters.remove(filter);
    else
      filters[filter] = value.trim();
  }

  Filters() {
  }

}