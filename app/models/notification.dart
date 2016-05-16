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

  Notification(this.id, this.created, this.read, String mentionedUser, String action, Map target) {
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
    _createText(mentionedUser, action);
  }

  String _emphasize(String toStrong) {
    return '<strong>' + toStrong + '</strong>';
  }

  _createText(String mentionedUser, String action) {
    if(action == 'wished')
      text = _emphasize(targetName) + " - píseň, co by se vám mohla líbit.";
    else {
      text = '';

      if (action.endsWith('by admin'))
        text += 'Administrátor ';
      else
        text += 'Uživatel ';

      text += _emphasize(mentionedUser);

      text += _evaluateAction(action);
    }
  }

  String _evaluateAction(String action){
    String text = ' ';
    bool owned = true;
    if(action.endsWith('taken'))
      owned = false;

    if(action.startsWith('deleted'))
      text += 'smazal ';
    if(action.startsWith('restored'))
      text += 'obnovil ';
    else if(action.startsWith('updated'))
      text += 'upravil ';
    else if(action.startsWith('canceled'))
      text += 'zrušil ';
    else
      switch(action){
        case 'copied':
          text += 'zkopíroval ';
          break;
        case 'rated':
          text += 'ohodnotil ';
          break;
        case 'taken':
          text += 'převzal ';
          break;
        case 'commented':
          text += 'okomentoval ';
          break;
        case 'shared':
          text += 's Vámi sdílel ';
        owned = false;
          break;
      }

    bool changeForm = false;
    if(action.endsWith('comment')) {
      text += 'komentář ';
      changeForm = true;
    }
    else if(action.endsWith('rating')) {
      text += 'hodnocení ';
      changeForm = true;
    }
    else if(action.endsWith('taking')) {
      text += 'převzetí ';
      changeForm = true;
    }

    switch(targetType){
      case 'glyphicon-music':
        if(owned)
          text += changeForm ? 'Vaší ' : 'Vaši ';
        text += changeForm ? 'písně ' : 'píseň ';
        break;
      case 'glyphicon-book':
        if(owned)
          text += changeForm ? 'Vašeho ' : 'Váš ';
        text += changeForm ? 'zpěvníku ' : 'zpěvník ';
        break;
    }
    text += _emphasize(targetName);

    if(action.endsWith('taken')) {
      text += targetType == 'glyphicon-music' ? ', kterou ' : ', který ';
      text += 'máte mezi převzatými';
    }
    text += '.';
    return text;
  }
}
