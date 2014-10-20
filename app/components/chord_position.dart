part of app;

@Component(
    selector: 'chpos',
    templateUrl: 'app/templates/chord_position.html',
    publishAs: 'cmp',
    useShadowDom: false
    )
class ChordPosition {
  @NgOneWay('offset')
  int offset;

  @NgTwoWay('ctrl')
  SongController ctrl;

  @NgOneWay('char')
  String char;

  bool chordEditor = false;

  String input = '';

  @NgOneWay('chord')
  String chord = '';

  @NgOneWay('editable')
  bool editable = true;

  void showChordEditor() {
    if (editable) {
      if (ctrl.song.chords.containsKey(offset.toString())) {
        input = ctrl.song.chords[offset.toString()];
      }
      chordEditor = true;
    }
  }

  void setChord() {
    if (input.isEmpty) {
      if (ctrl.song.chords.containsKey(offset.toString())) {
        ctrl.song.chords.remove(offset.toString());
      }
    } else {
      ctrl.song.chords[offset.toString()] = input;
    }

    chord = input;
    chordEditor = false;
  }
}
