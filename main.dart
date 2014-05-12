import 'package:angular/angular_dynamic.dart';
import 'app/FrontendModule.dart';

void main() {
  ngDynamicApp().addModule(new FrontendModule()).run();
}
