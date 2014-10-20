part of app;

void appRouteInitializer(Router router, RouteViewFactory view) {
  view.configure({
      'songs': ngRoute(
          path: '/songs',
          view: 'app/views/songs.html'),
      'sign': ngRoute(
         path: '/sign',
         view: 'app/views/sign_in.html'),
      'resetPassword': ngRoute(
          path: '/reset-password',
          mount: {
            'step1': ngRoute(
              path: '/step1',
              view: 'app/views/reset_password.html'
            ),
            'step2': ngRoute(
              path: '/step2/:token',
              view: 'app/views/set_new_password.html'
            )
          }
      ),
      'register': ngRoute(
          path: '/register',
          view: 'app/views/register.html'),
      'users': ngRoute(
          path: '/users',
          view: 'app/views/users.html'),
      'admin': ngRoute(
          path: '/admin',
          view: 'app/views/admin.html'),
      'homepage': ngRoute(
          defaultRoute: true,
          path: '/',
          view: 'app/views/homepage.html')
  });
}
