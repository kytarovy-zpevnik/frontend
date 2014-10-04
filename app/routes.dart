part of app;

void appRouteInitializer(Router router, RouteViewFactory view) {
  view.configure({
      'sign': ngRoute(
         path: '/sign',
         view: 'app/views/sign_in.html'),
      'homepage': ngRoute(
          defaultRoute: true,
          view: 'app/views/homepage.html')
  });
}
