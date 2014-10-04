part of app;

@Controller(selector: '[homepage]', publishAs: 'ctrl')
class HomepageController {
  final Router _router;

  HomepageController(this._router, MessageService messageService) {
    messageService.addInfo('Vítejte!', 'Toto je alfa verze kytarového zpěvníku.');
  }

  void signIn() {
    _router.go('sign', {});
  }
}