part of app;

void appRouteInitializer(Router router, RouteViewFactory view) {
  view.configure({
      'homepage': ngRoute(
          path: '/',
          view: 'app/views/homepage.html'),
      'sign': ngRoute(
         path: '/sign',
         view: 'app/views/sign.in.html')
  });
}
