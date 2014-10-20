part of app;

@Controller(selector: '[homepage]', publishAs: 'ctrl')
class HomepageController {
  final Router _router;

  HomepageController(this._router);

  void signIn() {
    _router.go('sign', {});
  }
}