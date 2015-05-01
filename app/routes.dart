part of app;

class Routes {

  final MessageService _messageService;

  Routes(this._messageService);

  void call(Router router, RouteViewFactory view) {
    view.configure({
        'wishes': appRoute(
            path: '/wishes',
            view: 'html/views/wishes.html'),
        'wish': appRoute(
            path: '/wish/:id',
            mount: {
                'view': appRoute(
                    path: '/view',
                    view: 'html/views/wish_view.html'),
                'edit': appRoute(
                    path: '/edit',
                    view: 'html/views/wish_edit.html')
            }),
        'createWish': appRoute(
            path: '/wish/create',
            view: 'html/views/wish_edit.html'),
        'songs': appRoute(
            path: '/songs',
            view: 'html/views/songs.html'),
        'public-songs': appRoute(
            path: '/public-songs',
            view: 'html/views/songs_public.html'),
        'songbooks': appRoute(
            path: '/songbooks',
            view: 'html/views/songbooks.html'),
        'public-songbooks': appRoute(
            path: '/public-songbooks',
            view: 'html/views/songbooks_public.html'),
        'sign': appRoute(
            path: '/sign',
            view: 'html/views/sign_in.html'),
        'resetPassword': appRoute(
            path: '/reset-password',
            mount: {
                'step1': appRoute(
                    path: '/step1',
                    view: 'html/views/reset_password.html'),
                'step2': appRoute(
                    path: '/step2/:token',
                    view: 'html/views/set_new_password.html')
            }),
        'importSong': appRoute(
            path: '/song/import',
            view: 'html/views/song_edit.html'),
        'createSong': appRoute(
            path: '/song/create',
            view: 'html/views/song_edit.html'),
        'createSongInSongbook': appRoute(
            path: '/song/create/songbook/:songbookId',
            view: 'html/views/song_edit.html'),
        'song': appRoute(
            path: '/song/:id',
            mount: {
                'view': appRoute(
                    path: '/view',
                    view: 'html/views/song_view.html'),
                'edit': appRoute(
                    path: '/edit',
                    view: 'html/views/song_edit.html'),
                'ratings': appRoute(
                    path: '/ratings',
                    view: 'html/views/song_ratings.html'),
                'rating': appRoute(
                    path: '/rating/edit',
                    view: 'html/views/song_rating_edit.html'),
                'share': appRoute(
                    path: '/sharing',
                    view: 'html/views/song_sharing.html')
            }),
        'editSongbook': appRoute(
            path: '/songbook/create',
            view: 'html/views/songbook_edit.html'
        ),
        'songbook': appRoute(
            path: '/songbook/:id',
            mount: {
                'view': appRoute(
                    path: '/view',
                    view: 'html/views/songbook_view.html'),
                'edit': appRoute(
                    path: '/edit',
                    view: 'html/views/songbook_edit.html'),
                'ratings': appRoute(
                    path: '/ratings',
                    view: 'html/views/songbook_ratings.html'),
                'rating': appRoute(
                    path: '/rating/edit',
                    view: 'html/views/songbook_rating_edit.html'),
                'share': appRoute(
                    path: '/sharing',
                    view: 'html/views/songbook_sharing.html')
            }),
        'register': appRoute(
            path: '/register',
            view: 'html/views/register.html'),
        'users': appRoute(
            path: '/users',
            view: 'html/views/users.html'),
        'admin': appRoute(
            path: '/admin',
            view: 'html/views/admin.html'),
        'admin-songs': appRoute(
            path: '/admin-songs',
            view: 'html/views/songs_admin.html'),
        'admin-songbooks': appRoute(
            path: '/admin-songbooks',
            view: 'html/views/songbooks_admin.html'),
        'notifications': appRoute(
            path: '/notifications',
            view: 'html/views/notifications.html'),
        'homepage': appRoute(
            defaultRoute: true,
            path: '/',
            view: 'html/views/homepage.html')
    });
  }

  NgRouteCfg appRoute({String path, String view, String viewHtml,
                      Map<String, NgRouteCfg> mount, modules(), bool defaultRoute: false,
                      RoutePreEnterEventHandler preEnter, RouteEnterEventHandler enter,
                      RoutePreLeaveEventHandler preLeave, RouteLeaveEventHandler leave,
                      dontLeaveOnParamChanges: false}) =>
  ngRoute(path: path, view: view, viewHtml: viewHtml, mount: mount,
  modules: modules, defaultRoute: defaultRoute, preEnter: preEnter, preLeave: preLeave,
  enter: (e) {
    _messageService.showStacked();
//    enter(e);
  }, leave: leave,
  dontLeaveOnParamChanges: dontLeaveOnParamChanges);
}