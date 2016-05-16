part of app;

@Controller(selector: '[notifications]', publishAs: 'ctrl')
class NotificationsController {
  final NotificationService _notificationService;
  final MessageService _messageService;

  List<Notification> toDelete = [];
  bool deleting = false;

  var formatter = new DateFormat('d.M.yyyy H:m');

  NotificationsController(this._notificationService, this._messageService);

  List<Notification> get notifications => _notificationService.notifications;

  void readNotification(Notification notification) {
    if (!notification.read) {
      _notificationService.readNotification(notification);
    }
  }

  void readAllNotifications() {
    _notificationService.readAllNotifications();
  }

  void deleteNotifications() {
    if(!toDelete.isEmpty) {
      _notificationService.deleteNotifications(toDelete).then((_) {
        toDelete.clear();
        _messageService.showSuccess('Smazáno.', 'Notifikace byly úspěšně smazány.');
      });
    }
    deleting = false;
  }
}
