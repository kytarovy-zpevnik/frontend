part of app;

/**
 * Top navigation bar component.
 */
@Component(
    selector: 'bar',
    templateUrl: 'html/templates/bar.html',
    publishAs: 'cmp',
    useShadowDom: false)
class BarComponent {
  final SessionService _sessionService;
  final MessageService _messageService;
  final Router _router;
  final NotificationService _notificationService;

  BarComponent(this._sessionService, this._messageService, this._router, this._notificationService);

  List<Notification> get notifications => _notificationService.unread;

  int get unread => _notificationService.unread.length;

  bool get loggedIn => _sessionService.session != null;

  bool get admin => _sessionService.session != null && _sessionService.session.user.role.slug == 'admin';

  String get username => _sessionService.session.user.username;

  void readNotification(Notification notification){
    _notificationService.readNotification(notification);
  }

  void signOut() {
    _sessionService.terminate().then((_) {
      _messageService.prepareSuccess('Odhlášen.', 'Úšpěšně odhlášen.');
      _router.go('homepage', {});
    });
  }


}
