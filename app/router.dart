import 'package:angular/angular.dart';

void RouterInitializer(Router router, ViewFactory views) {
  views.configure({
      'homepage': ngRoute(
        path: '/',
        view: 'app/views/homepage.html'),
      'sign': ngRoute(
         path: '/sign',
         view: 'app/views/sign.in.html')
  });
}