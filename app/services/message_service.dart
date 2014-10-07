part of app;

@Injectable()
class MessageService {
  List<Message> _messages = [];

  MessageService(Router router) {
    router.root.onPreEnter.listen((_) {
      print('bar');
      _messages.clear();
    });
  }

  void addSuccess(String title, String text) {
    _messages.add(new Message('success', title, text));
  }

  void addInfo(String title, String text) {
    _messages.add(new Message('info', title, text));
  }

  void addWarning(String title, String text) {
    _messages.add(new Message('warning', title, text));
  }

  void addError(String title, String text) {
    _messages.add(new Message('danger', title, text));
  }

  List<Message> get messages => _messages;
}
