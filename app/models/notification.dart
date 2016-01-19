part of app;

/**
 * Notification model object.
 */
class Notification {
  int id;
  DateTime created;
  bool read;
  String text;
  User user;
  String targetName;
  String targetType;
  String url = '';

  Notification(this.id, this.created, this.read, this.text, Map target) {
    text = text.replaceAllMapped(new RegExp(r'"(.*?)"'), (Match match) {
      return ("<b>" + match.group(0) + "</b>").replaceAll('"','');
    });

    if (target != null && !target.isEmpty) {
      if (target.containsKey('song')) {
        targetType = 'glyphicon-music';
        targetName = target['song']['title'];
        url = '/song/' + target['song']['id'].toString() + '/view';

      } else if (target.containsKey('songbook')) {
        targetType = 'glyphicon-book';
        targetName = target['songbook']['name'];
        url = '/songbook/' + target['songbook']['id'].toString() + '/view';
      }
    }
  }
}
