part of app;

void appRouteInitializer(Router router, RouteViewFactory view) {
  view.configure({
      'sign': ngRoute(
         path: '/sign',
         view: 'app/views/sign_in.html'),
      'register': ngRoute(
          path: '/register',
          view: 'app/views/register.html'),
      'homepage': ngRoute(
          defaultRoute: true,
          path: '/',
          view: 'app/views/homepage.html')
  });
}
