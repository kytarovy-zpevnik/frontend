part of app;

@Controller(selector: '[notifications]', publishAs: 'ctrl')
class NotificationsController {
  final NotificationService _notificationService;

  //List<Notification> notifications = [];

  var formatter = new DateFormat('d. M. yyyy H:m');

  NotificationsController(this._notificationService);

  List<Notification> get notifications => _notificationService.notifications;

  void readNotification(Notification notification) {
    if (!notification.read) {
      _notificationService.readNotification(notification);
    }
  }

  void readAllNotifications() {
    _notificationService.readAllNotifications();
  }
}
