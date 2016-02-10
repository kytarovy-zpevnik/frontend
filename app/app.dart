library app;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:intl/intl.dart';
import 'dart:js' as js;

part 'components/bar_component.dart';
part 'components/chord_position.dart';
part 'components/messages_component.dart';
part 'components/song_search.dart';

part 'controllers/admin_songbooks_controller.dart';
part 'controllers/admin_songs_controller.dart';
part 'controllers/homepage_controller.dart';
part 'controllers/notifications_controller.dart';
part 'controllers/public_songbooks_controller.dart';
part 'controllers/public_songs_controller.dart';
part 'controllers/register_controller.dart';
part 'controllers/reset_password_controller.dart';
part 'controllers/sign_in_controller.dart';
part 'controllers/song_comments_controller.dart';
part 'controllers/song_controller.dart';
part 'controllers/song_edit_controller.dart';
part 'controllers/song_ratings_controller.dart';
part 'controllers/songbook_comments_controller.dart';
part 'controllers/songbook_controller.dart';
part 'controllers/songbook_ratings_controller.dart';
part 'controllers/songbooks_controller.dart';
part 'controllers/songs_controller.dart';
part 'controllers/user_controller.dart';
part 'controllers/wish_controller.dart';
part 'controllers/wishes_controller.dart';
part 'controllers/guide_controller.dart';

part 'models/api_error.dart';
part 'models/comment.dart';
part 'models/message.dart';
part 'models/notification.dart';
part 'models/rating.dart';
part 'models/role.dart';
part 'models/server_error.dart';
part 'models/session.dart';
part 'models/song.dart';
part 'models/songbook.dart';
part 'models/songbookTag.dart';
part 'models/songTag.dart';
part 'models/user.dart';
part 'models/wish.dart';

part 'resources/notifications_resource.dart';
part 'resources/reset_password_resource.dart';
part 'resources/session_resource.dart';
part 'resources/song_comments_resource.dart';
part 'resources/song_rating_resource.dart';
part 'resources/song_sharing_resource.dart';
part 'resources/songbook_comments_resource.dart';
part 'resources/songbook_rating_resource.dart';
part 'resources/songbook_sharing_resource.dart';
part 'resources/songbooks_resource.dart';
part 'resources/songs_resource.dart';
part 'resources/user_resource.dart';
part 'resources/wishes_resource.dart';

part 'services/api.dart';
part 'services/message_service.dart';
part 'services/notification_service.dart';
part 'services/session_service.dart';

part 'routes.dart';
part 'values.dart';

class AppModule extends Module {
  AppModule() {
    bind(BarComponent);
    bind(ChordPosition);
    bind(MessagesComponent);
    bind(SongSearch);

    bind(AdminSongbooksController);
    bind(AdminSongsController);
    bind(HomepageController);
    bind(NotificationsController);
    bind(PublicSongbooksController);
    bind(PublicSongsController);
    bind(RegisterController);
    bind(ResetPasswordController);
    bind(SignInController);
    bind(SongCommentsController);
    bind(SongController);
    bind(SongEditController);
    bind(SongRatingsController);
    bind(SongbookCommentsController);
    bind(SongbookController);
    bind(SongbookRatingsController);
    bind(SongbooksController);
    bind(SongsController);
    bind(UserController);
    bind(WishController);
    bind(WishesController);
    bind(GuideController);

    bind(NotificationsResource);
    bind(ResetPasswordResource);
    bind(SessionResource);
    bind(SongCommentsResource);
    bind(SongRatingResource);
    bind(SongSharingResource);
    bind(SongbookCommentsResource);
    bind(SongbookRatingResource);
    bind(SongbookSharingResource);
    bind(SongbooksResource);
    bind(SongsResource);
    bind(UserResource);
    bind(WishesResource);

    bind(Api);
    bind(MessageService);
    bind(NotificationService);
    bind(SessionService);

    bind(RouteInitializerFn, toImplementation: Routes);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    bind(ApiHost, toValue: new ApiHost('api/frontend/1'));
    bind(SessionToken);
  }
}
