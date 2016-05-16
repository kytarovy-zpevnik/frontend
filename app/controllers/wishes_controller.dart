part of app;

@Controller(selector: '[wishes]', publishAs: 'ctrl')
class WishesController {

  final WishesResource _wishesResource;

  List wishes = [];

  var formatter = new DateFormat('d.M.yyyy HH:mm');

  WishesController(this._wishesResource) {
    _wishesResource.readAll().then(_processWishes);
  }

  void _processWishes(List<Wish> wishes) {
    this.wishes.clear();
    List row;
    var index = 0;
    wishes.forEach((Wish wish) {
      if(index % 4 == 0){
        row = [];
        row.add(wish);
        this.wishes.add(row);
      }
      else{
        row.add(wish);
      }
      index++;
    });
  }

}