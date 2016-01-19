part of app;

@Injectable()
class NotificationService {
  final SessionService _sessionService;
  final NotificationsResource _notificationsResource;

  List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  List<Notification> _unread = [];

  List<Notification> get unread => _unread;

  NotificationService(this._sessionService, this._notificationsResource) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){
    if(_sessionService.session != null) {
      loadNotifications().then((_){
        querySelector('html').classes.remove('wait');
      });
    }
    else {
      querySelector('html').classes.remove('wait');
    }
  }

  Future loadNotifications(){
    _notifications.clear();
    return _notificationsResource.readAll().then((notifications) {
      notifications.forEach((notification) {
        _notifications.add(notification);
        if(!notification.read)
          _unread.add(notification);
      });
    });

  }

  void readNotification(Notification notification) {
    _notificationsResource.update(notification, true).then((_) {
      notification.read = true;
      _unread.remove(notification);
    });
  }

  void readAllNotifications() {
    _notificationsResource.updateAll(true).then((_) {
      notifications.forEach((Notification notification){
        notification.read = true;
      });
      _unread.clear();
    });
  }

}
