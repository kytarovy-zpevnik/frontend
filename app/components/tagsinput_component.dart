part of app;

@Component(
    selector: 'tagsinput',
    templateUrl: 'html/templates/tagsinput.html',
    /*cssUrl: 'css/bootstrap.min.css',*/
    publishAs: 'cmp',
    useShadowDom: false)
class TagsinputComponent {
  @NgTwoWay('tags')
  String _tags;

  Element el;
  List<Element> content;

  TagsinputComponent(Element e) {
    el = e;
    content = <Element>[].addAll(e.children);
  }

  edit() {
    var tagsInput = el.querySelector('input');
  }
}
