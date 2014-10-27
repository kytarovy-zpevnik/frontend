part of app;

class Routes {

  final MessageService _messageService;

  Routes(this._messageService);

  void call(Router router, RouteViewFactory view) {
    view.configure({
        'songs': appRoute(
            path: '/songs',
            view: 'html/views/songs.html'),
        'songbooks': appRoute(
            path: '/songbooks',
            view: 'html/views/songbooks.html'),
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
                    view: 'html/views/song_edit.html')
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
                    view: 'html/views/songbook_edit.html')
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
          enter: (e) { _messageService.showStacked(); enter(e); }, leave: leave,
          dontLeaveOnParamChanges: dontLeaveOnParamChanges);
}
