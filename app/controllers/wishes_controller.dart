part of app;

@Controller(selector: '[wishes]', publishAs: 'ctrl')
class WishesController {

  final WishesResource _wishesResource;

  List wishes = [];

  int tab = 0;

  WishesController(this._wishesResource) {
    _wishesResource.readAll().then(_processWishes);
  }

  void _processWishes(List<Wish> wishes) {
    this.wishes.clear();
    wishes.forEach((Wish wish) {
      this.wishes.add(wish);;
    });
  }

}