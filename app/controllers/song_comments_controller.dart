part of app;

@Controller(selector: '[song-comments]', publishAs: 'ctrl2')
class SongCommentsController {

  SongCommentsResource _commentsResource;
  SessionService _sessionService = null;
  MessageService _messageService;
  Router _router;
  RouteProvider _routeProvider;

  List comments = [];
  User user;
  Comment comment;
  Comment editComment;
  int songId;
  int editId;

  var formatter = new DateFormat('d. M. yyyy H:m');

  SongCommentsController(this._router, this._messageService, this._commentsResource, this._sessionService, this._routeProvider) {
    refresh();
  }

  void _processComments(List<Comment> comments) {
    this.comments.clear();
    comments.forEach((Comment comment) {
      this.comments.add(comment);
    });
  }

  void save() {
    _commentsResource.createComment(songId, this.comment).then((_) {
      _messageService.showSuccess('Vytvořeno.', 'Nový komentář byla úspěšně přidán.');
      refresh();
      _router.go('song.view', {'id': this.songId});
    });
  }

  void delete(int id) {
    _commentsResource.deleteComment(songId, id).then((_) {
      _messageService.showSuccess('Odstraněno.', 'Komentář byla úspěšně odebrán.');
      refresh();
      _router.go('song.view', {'id': this.songId});
    });
  }

  void commentEdit() {
    _commentsResource.editComment(songId, editComment).then((_) {
      _messageService.showSuccess('Změněno.', 'Komentář byl úspěšně změněn.');
      refresh();
      _router.go('song.view', {'id': this.songId});
    });
  }

  void prepareEdit(int id) {
    this.editId = id;
    _commentsResource.readComment(songId, editId).then((Comment comment){
      this.editComment = comment;
    });
  }

  void refresh() {
    querySelector('html').classes.add('wait');
    _sessionService.initialized.then((_) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);

      this.comment = new Comment();
      this.editComment = new Comment();
      songId = _routeProvider.parameters['id'];
      editId = 0;
      _commentsResource.readAllComments(songId).then(_processComments);
      querySelector('html').classes.remove('wait');
    });
  }
}
