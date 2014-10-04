part of app;

/**
 * Error/warning/info/success message.
 */
class Message {
  final String type;
  final String title;
  final String text;

  Message(String this.type, String this.title, String this.text);
}
