part of app;

@Controller(selector: '[songbook-ratings]', publishAs: 'ctrl')
class SongbookRatingsController {

  final SongbookRatingResource _ratingResource;
  final SongbooksResource _songbooksResource;
  MessageService _messageService;
  SessionService _sessionService;
  RouteProvider _routeProvider;

  List ratings = [];
  Rating newRating;
  int ratingSum;
  int avgRating;

  User user;
  Songbook songbook;
  bool rated = false;

  SongbookRatingsController(this._sessionService, this._ratingResource, this._songbooksResource, this._messageService, this._routeProvider) {
    querySelector('html').classes.add('wait');
    if (_sessionService.session == null) {
      _sessionService.initialized.then((_) {
        _initialize();
      });
    } else {
      _initialize();
    }
  }

  _initialize(){
    if (_sessionService.session != null) {
      User currentUser = _sessionService.session.user;
      this.user = new User(currentUser.id, currentUser.username, currentUser.email, currentUser.role, currentUser.lastLogin);
    }

    Future.wait([
        _songbooksResource.read(_routeProvider.parameters['id']).then((Songbook songbook){
          this.songbook = songbook;
        }),
        _ratingResource.readAllRating(_routeProvider.parameters['id']).then(_processRatings)]
    ).then((List<Future> futures){

      js.context.callMethod(r'$', ['#rating']).callMethod('modal', [new js.JsObject.jsify({'show': 'true'})]);

      querySelector('html').classes.remove('wait');
    });
  }

  void _processRatings(List<Rating> ratings) {
    avgRating = 0;
    ratingSum = 0;
    this.ratings.clear();
    List row;
    var index = 0;
    ratings.forEach((Rating rating) {
      ratingSum++;
      avgRating += rating.rating;
      if (this.user != null && rating.userId == this.user.id) {
        this.rated = true;
        this.newRating = rating;
      }

      if(index % 3 == 0){
        row = [];
        row.add(rating);
        this.ratings.add(row);
      }
      else{
        row.add(rating);
      }
      index++;
      //this.ratings.add(rating);
    });
    if(!this.rated){
      this.newRating = new Rating();
      this.newRating.rating = 1;
    }
    if(ratingSum != 0){
      avgRating /= ratingSum;
    }
  }

  void saveRating() {
    querySelector('html').classes.add('wait');
    if (!rated) {
      rated = true;
      _ratingResource.createRating(songbook.id, newRating).then((_){
        _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
          _processRatings(ratings);
          _messageService.showSuccess('Vytvořeno.', 'Nové hodnocení bylo úspěšně vytvořeno.');
          querySelector('html').classes.remove('wait');
        });
      });
    }
    else {
      _ratingResource.updateRating(songbook.id, newRating).then((_){
        _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
          _processRatings(ratings);
          _messageService.showSuccess('Uloženo.', 'Hodnocení bylo úspěšně uloženo.');
          querySelector('html').classes.remove('wait');
        });
      });
    }
  }

  void deleteRating(){
    querySelector('html').classes.add('wait');
    _ratingResource.deleteRating(songbook.id, newRating).then((_) {
      rated = false;
      _ratingResource.readAllRating(_routeProvider.parameters['id']).then((List<Rating> ratings){
        _processRatings(ratings);
        _messageService.showSuccess('Odstraněno.', 'Hodnocení bylo úspěšně odebráno.');
        querySelector('html').classes.remove('wait');
      });
    });
  }

}