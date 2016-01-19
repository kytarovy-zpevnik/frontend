part of app;

/**
 * Notification resource.
 */
@Injectable()
class NotificationsResource {
  final Api _api;

  NotificationsResource(this._api);

  /**
   * Returns all (or unread only) notifications for currently logged user.
   */
  Future<List<Notification>> readAll([bool unreadOnly = false]) {
    var params = unreadOnly
      ? {'unread': unreadOnly}
      : {};
    return _api.get('notifications', params: params).then((HttpResponse response) {
      var notifications = response.data.map((data) {
        return new Notification(data['id'], DateTime.parse(data['created']), data['read'], data['text'], data['target']);
      });
      return new Future.value(notifications);
    });
  }

  /**
   * Marks all notifications as read.
   */
  Future updateAll(bool read) {
    return _api.put('notifications', data: {'read' : read}).then((_) {
      return new Future.value();
    });
  }

  /**
   * Marks given notification as read.
   */
  Future update(Notification notification, bool read) {
    return _api.put('notifications/' + notification.id.toString(), data: {'read' : read}).then((_) {
      return new Future.value();
    });
  }
}
