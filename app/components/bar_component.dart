part of app;

@Component(
    selector: 'bar',
    templateUrl: 'app/templates/bar.html',
    cssUrl: 'css/bootstrap.min.css',
    publishAs: 'cmp')
class BarComponent {
  final SessionService _sessionService;
  final MessageService _messageService;

  BarComponent(this._sessionService, this._messageService);

  bool get loggedIn => _sessionService.session != null;

  bool get admin => _sessionService.session != null && _sessionService.session.user.role.slug == 'admin';

  void signOut() {
    _sessionService.terminate().then((_) {
      _messageService.addSuccess('Odhlášen.', 'Ušpěšně odhlášen.');
    });
  }
}
