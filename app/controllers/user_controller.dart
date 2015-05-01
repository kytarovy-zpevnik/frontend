part of app;

@Controller(selector: '[user]', publishAs: 'ctrl')
class UserController {
  final UserResource _userResource;
  final MessageService _messageService;
  final SessionService _sessionService;

  List<User> users = [];
  User currentUser;

  UserController(this._sessionService, this._userResource, this._messageService) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize() {
    User currentUser = _sessionService.session.user;
    this.currentUser = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);

    _loadUsers();
  }

    void toAdmin(int index) {
    users[index].role.slug = 'admin';
    _userResource.update(users[index]);
  }

  void toRegistered(int index) {
    users[index].role.slug = 'registered';
    _userResource.update(users[index]);
  }

  void _loadUsers() {
    _userResource.readAll().then((List<User> users) {
      users.forEach((User user) {
        this.users.add(user);
      });
      querySelector('html').classes.remove('wait');
    });
  }
}