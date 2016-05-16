part of app;

@Controller(selector: '[songbook-comments]', publishAs: 'ctrl2')
class SongbookCommentsController {

  SongbookCommentsResource _commentsResource;
  SessionService _sessionService;
  MessageService _messageService;
  RouteProvider _routeProvider;

  List comments = [];
  User user;
  Comment comment;
  int songbookId;

  var formatter = new DateFormat('d.M.yyyy HH:mm');

  SongbookCommentsController(this._messageService, this._commentsResource, this._sessionService, this._routeProvider) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {  // analogicky u dalších controllerů
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){
    if(_sessionService.session != null) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    }

    songbookId = _routeProvider.parameters['id'];
    loadComments();
  }

  Future loadComments() {
    querySelector('html').classes.add('wait');
    return _commentsResource.readAllComments(songbookId).then((List<Comment> comments) {
      _processComments(comments);
      comment = new Comment();
      comment.id = -1;
      querySelector('html').classes.remove('wait');
      return new Future.value(null);
    });
  }

  void _processComments(List<Comment> comments) {
    this.comments.clear();
    comments.forEach((Comment comment) {
      this.comments.add(comment);
    });
  }

  void save() {
    if(this.comment.id == -1) {
      _commentsResource.createComment(songbookId, comment).then((_) {
        _messageService.showSuccess('Vytvořeno.', 'Nový komentář byl úspěšně přidán.');
        loadComments();
      });
    }
    else {
      _commentsResource.updateComment(songbookId, comment).then((_) {
        _messageService.showSuccess('Upraveno.', 'Komentář byl úspěšně upraven.');
        loadComments();
      });
    }
  }

  void delete(Comment comment) {
    _commentsResource.deleteComment(songbookId, comment.id).then((_) {
      _messageService.showSuccess('Odstraněno.', 'Komentář byl úspěšně odebrán.');
      comments.remove(comment);
    });
  }

  void prepareEdit(Comment comment) {
    this.comment.id = comment.id;
    this.comment.comment = comment.comment;
  }
}
