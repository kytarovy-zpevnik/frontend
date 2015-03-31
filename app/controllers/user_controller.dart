part of app;

@Controller(selector: '[user]', publishAs: 'ctrl')
class UserController {
  final UserResource _userResource;
  final MessageService _messageService;

  List<User> users = [];

  UserController(this._userResource, this._messageService) {
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
    querySelector('html').classes.add('wait');
    _userResource.readAll().then((List<User> users) {
      users.forEach((User user) {
        this.users.add(user);
      });
      querySelector('html').classes.remove('wait');
    });
  }
}