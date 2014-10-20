library app;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'dart:async';
import 'dart:convert';

part 'components/bar_component.dart';
part 'components/chord_position.dart';
part 'components/messages_component.dart';
part 'controllers/homepage_controller.dart';
part 'controllers/register_controller.dart';
part 'controllers/reset_password_controller.dart';
part 'controllers/sign_in_controller.dart';
part 'controllers/songbooks_controller.dart';
part 'controllers/song_controller.dart';
part 'controllers/songs_controller.dart';
part 'controllers/user_controller.dart';
part 'models/api_error.dart';
part 'models/message.dart';
part 'models/role.dart';
part 'models/server_error.dart';
part 'models/session.dart';
part 'models/song.dart';
part 'models/songbook.dart';
part 'models/user.dart';
part 'resources/reset_password_resource';
part 'resources/session_resource.dart';
part 'resources/songbooks_resource.dart';
part 'resources/songs_resource.dart';
part 'resources/user_resource.dart';
part 'services/api.dart';
part 'services/message_service.dart';
part 'services/session_service.dart';
part 'routes.dart';
part 'values.dart';

class AppModule extends Module {
  AppModule() {
    bind(BarComponent);
    bind(ChordPosition);
    bind(MessagesComponent);
    bind(HomepageController);
    bind(RegisterController);
    bind(ResetPasswordController);
    bind(SignInController);
    bind(SongbooksController);
    bind(SongController);
    bind(SongsController);
    bind(UserController);
    bind(ResetPasswordResource);
    bind(SessionResource);
    bind(SongbooksResource);
    bind(SongsResource);
    bind(UserResource);
    bind(Api);
    bind(MessageService);
    bind(SessionService);

    bind(RouteInitializerFn, toValue: appRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    bind(ApiHost, toValue: new ApiHost('api/frontend/1'));
    bind(SessionToken);
  }
}
