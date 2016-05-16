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

  @NgOneWay('text')
  String text;

  @NgOneWay('hypen')
  bool hypen = true;

  @NgOneWay('padding')
  bool padding = true;

  @NgOneWay('chord')
  String chord = '';

  bool chordEditor = false;

  String input = '';

  int editorOffset;

  ChordPosition() {
  }

  void attach() {
    if(ctrl != null)
      ctrl.addChpos(this);
  }

  void showChordEditor(int index) {
    if (ctrl != null) {
      editorOffset = offset + index;
      ctrl.hideChordEditors();

      if (editorOffset == offset) {
        input = ctrl.song.chords[offset.toString()];
      }
      chordEditor = true;
    }
  }

  void setChord() {
    if (ctrl != null) {
      if (input.isEmpty) {
        if (editorOffset == offset) {
          ctrl.song.chords.remove(offset.toString());
        }
      } else {
        ctrl.song.chords[editorOffset.toString()] = input;
      }

      chordEditor = false;
      ctrl.computeLyrics();
    }
  }

  void hideChordEditor() {
    chordEditor = false;
  }
}
