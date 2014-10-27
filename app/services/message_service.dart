part of app;

@Injectable()
class MessageService {
  List<Message> _messages = [];
  List<Message> _stack = [];

  void showStacked() {
    _messages.clear();
    _stack.forEach((message) {
      _messages.add(message);
    });
    _stack.clear();
  }

  /**
   * Displays immediately success message with title and text.
   */
  void showSuccess(String title, String text) {
    _messages.add(new Message('success', title, text));
  }

  /**
   * Displays immediately info message with title and text.
   */
  void showInfo(String title, String text) {
    _messages.add(new Message('info', title, text));
  }

  /**
   * Displays immediately warning message with title and text.
   */
  void showWarning(String title, String text) {
    _messages.add(new Message('warning', title, text));
  }

  /**
   * Displays immediately error message with title and text.
   */
  void showError(String title, String text) {
    _messages.add(new Message('danger', title, text));
  }

  /**
   * Displays success message with title and text on next view.
   */
  void prepareSuccess(String title, String text) {
    _stack.add(new Message('success', title, text));
  }

  /**
   * Displays info message with title and text on next view.
   */
  void prepareInfo(String title, String text) {
    print('prepareInfo!');
    _stack.add(new Message('info', title, text));
  }

  /**
   * Displays warning message with title and text on next view.
   */
  void prepareWarning(String title, String text) {
    _stack.add(new Message('warning', title, text));
  }

  /**
   * Displays error message with title and text on next view.
   */
  void prepareError(String title, String text) {
    _stack.add(new Message('danger', title, text));
  }

  /**
   * Removes message on given index.
   */
  void removeMessage(int index) {
    _messages.removeAt(index);
  }

  List<Message> get messages => _messages;
}
