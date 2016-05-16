part of app;

@Controller(selector: '[guide]', publishAs: 'ctrl')
class GuideController {

  void scrollTo(id){
    window.scrollTo(0, querySelector(id).getBoundingClientRect().top + window.pageYOffset - 65);
  }
}