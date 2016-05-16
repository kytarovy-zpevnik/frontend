part of app;

@Component(
    selector: 'chpos',
    templateUrl: 'html/templates/chord_position.html',
    publishAs: 'cmp',
    useShadowDom: false)
class ChordPosition implements AttachAware {
  @NgOneWay('offset')
  int offset;

  @NgTwoWay('ctrl')
  SongEditController ctrl = null;

  @NgOneWay('char')
  String char;

  bool chordEditor = false;

  String input = '';

  @NgOneWay('chord')
  String chord = '';

  @NgOneWay('editable')
  bool editable = true;

  @NgOneWay('hypen')
  bool hypen = true;

  ChordPosition() {
  }

  void attach() {
    if(ctrl != null)
      ctrl.addChpos(this);
  }

  void showChordEditor(int index) {
    if (ctrl != null) {
      ctrl.hideChordEditors();

      if (ctrl.song.chords.containsKey(offset.toString())) {
        input = ctrl.song.chords[offset.toString()];
      }
      chordEditor = true;
    }
  }

  void setChord() {
    if (ctrl != null) {
      if (input.isEmpty) {
        if (ctrl.song.chords.containsKey(offset.toString())) 
          ctrl.song.chords.remove(offset.toString());
      } else {
        ctrl.song.chords[offset.toString()] = input;
      }

      chordEditor = false;
      chord = input;
    }
  }

  void hideChordEditor() {
    chordEditor = false;
  }
}
