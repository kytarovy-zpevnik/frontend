part of app;

@Component(
    selector: 'bar',
    templateUrl: 'html/templates/bar.html',
    publishAs: 'cmp',
    useShadowDom: false)
class BarComponent {
  final SessionService _sessionService;
  final MessageService _messageService;
  final Router _router;

  BarComponent(this._sessionService, this._messageService, this._router);

  bool get loggedIn => _sessionService.session != null;

  bool get admin => _sessionService.session != null && _sessionService.session.user.role.slug == 'admin';

  void signOut() {
    _sessionService.terminate().then((_) {
      _messageService.prepareSuccess('Odhlášen.', 'Úšpěšně odhlášen.');
      _router.go('homepage', {});
    });
  }
}
