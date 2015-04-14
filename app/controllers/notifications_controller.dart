part of app;

@Controller(selector: '[notifications]', publishAs: 'ctrl')
class NotificationsController {
  final NotificationsResource _notificationsResource;

  List<Notification> notifications = [];

  var formatter = new DateFormat('d. M. yyyy H:m');

  NotificationsController(this._notificationsResource) {
    querySelector('html').classes.add('wait');
    _notificationsResource.readAll().then((notifications) {
      notifications.forEach((notification) {
        this.notifications.add(notification);
      });
      querySelector('html').classes.remove('wait');
    });
  }
}
