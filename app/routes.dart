part of app;

void appRouteInitializer(Router router, RouteViewFactory view) {
  view.configure({
      'songs': ngRoute(
          path: '/songs',
          view: 'html/views/songs.html'),
      'songbooks': ngRoute(
          path: '/songbooks',
          view: 'html/views/songbooks.html'),
      'sign': ngRoute(
          path: '/sign',
          view: 'html/views/sign_in.html'),
      'resetPassword': ngRoute(
          path: '/reset-password',
          mount: {
              'step1': ngRoute(
                  path: '/step1',
                  view: 'html/views/reset_password.html'),
              'step2': ngRoute(
                  path: '/step2/:token',
                  view: 'html/views/set_new_password.html')
          }),
      'createSong': ngRoute(
          path: '/song/create',
          view: 'html/views/song_edit.html'),
      'createSongInSongbook': ngRoute(
          path: '/song/create/songbook/:songbookId',
          view: 'html/views/song_edit.html'),
      'song': ngRoute(
          path: '/song/:id',
          mount: {
              'view': ngRoute(
                  path: '/view',
                  view: 'html/views/song_view.html'),
              'edit': ngRoute(
                  path: '/edit',
                  view: 'html/views/song_edit.html')
          }),
      'editSongbook': ngRoute(
        path: '/songbook/create',
        view: 'html/views/songbook_edit.html'
      ),
      'songbook': ngRoute(
          path: '/songbook/:id',
          mount: {
              'view': ngRoute(
                  path: '/view',
                  view: 'html/views/songbook_view.html'),
              'edit': ngRoute(
                  path: '/edit',
                  view: 'html/views/songbook_edit.html')
          }),
      'register': ngRoute(
          path: '/register',
          view: 'html/views/register.html'),
      'users': ngRoute(
          path: '/users',
          view: 'html/views/users.html'),
      'admin': ngRoute(
          path: '/admin',
          view: 'html/views/admin.html'),
      'homepage': ngRoute(
          defaultRoute: true,
          path: '/',
          view: 'html/views/homepage.html')
  });
}
