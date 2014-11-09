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
  final NotificationsResource _notificationsResource;

  bool unread = 0;
  List<Notification> notifications = [];

  BarComponent(this._sessionService, this._messageService, this._router, this._notificationsResource) {
    _loadNotifications().then((_) {
      unread = notifications.length;
    });
  }

  bool get loggedIn => _sessionService.session != null;

  bool get admin => _sessionService.session != null && _sessionService.session.user.role.slug == 'admin';

  void readNotifications() {
    _notificationsResource.updateAll(true).then((_) {
      unread = 0;
    });
  }

  Future _loadNotifications() {
    return _notificationsResource.readAll(true).then((notifications) {
      this.notifications.clear();
      notifications.forEach((notification) {
        this.notifications.add(notification);
      });
      return new Future.value();
    });
  }

  void signOut() {
    _sessionService.terminate().then((_) {
      _messageService.prepareSuccess('Odhlášen.', 'Úšpěšně odhlášen.');
      _router.go('homepage', {});
    });
  }


}
