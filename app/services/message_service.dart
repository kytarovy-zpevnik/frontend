part of app;

@Injectable()
class MessageService {
  List<Message> _messages = [];

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
