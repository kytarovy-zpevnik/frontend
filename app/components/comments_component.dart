part of app;

/**
 * Top comments component.
 */
@Component(
    selector: 'comments',
    templateUrl: 'html/templates/comments.html',
    publishAs: 'cmp',
    useShadowDom: false)
class CommentsComponent {
  final SessionService _sessionService;
  final MessageService _messageService;
  final Router _router;
  final NotificationsResource _notificationsResource;


  CommentsComponent(this._sessionService, this._messageService, this._router, this._notificationsResource) {
  }

  bool get loggedIn => _sessionService.session != null;

  bool get admin => _sessionService.session != null && _sessionService.session.user.role.slug == 'admin';




}
