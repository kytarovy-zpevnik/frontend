import 'package:angular/angular.dart';
import 'services/SignInService.dart';
import 'controllers/SignInController.dart';
import 'controllers/HomepageController.dart';
import 'router.dart';
import 'package:angular/routing/module.dart';

class FrontendModule extends Module {
  static const String API_HOST = 'http://private-4bbe-kytarovyzpevnik.apiary-mock.com';

  FrontendModule() {
    type(SignInService);
    type(SignInController);
    type(HomepageController);

    bind(RouteInitializerFn, toValue: RouterInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}