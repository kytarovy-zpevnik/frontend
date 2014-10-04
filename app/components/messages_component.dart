part of app;

@Component(
    selector: 'messages',
    templateUrl: 'app/templates/messages.html',
    cssUrl: 'css/bootstrap.min.css',
    publishAs: 'cmp')
class MessagesComponent {
  final MessageService _messagesService;

  MessagesComponent(this._messagesService);

  List<Message> get messages => _messagesService.messages;
}
