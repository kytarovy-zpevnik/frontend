library app;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'dart:async';
import 'dart:convert';

part 'controllers/homepage_controller.dart';
part 'controllers/sign_in_controller.dart';
part 'models/session.dart';
part 'models/user.dart';
part 'resources/session_resource.dart';
part 'services/api.dart';
part 'services/session_service.dart';
part 'routes.dart';
part 'values.dart';

class AppModule extends Module {
  AppModule() {
    bind(HomepageController);
    bind(SignInController);
    bind(SessionResource);
    bind(Api);
    bind(SessionService);

    bind(RouteInitializerFn, toValue: appRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    bind(ApiHost, toValue: new ApiHost('http://private-4bbe-kytarovyzpevnik.apiary-mock.com'));
  }
}
