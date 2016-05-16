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
        return new Notification(data['id'], DateTime.parse(data['created']),
                              data['read'], data['username'], data['action'], data['target']);
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
   * Deletes all given notifications.
   */
  Future deleteAll(List notifications) {
    var ids = [];
    notifications.forEach((notification) {
      ids.add({
          'id': notification.id
      });
    });

    return _api.delete('notifications', data: {
        'notifications': ids
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
