library chord;

/// The main Chord data class.
class Chord {
  late Note note;
  late ChordType chordType;
  late List<ChordProperty> properties;

  // Chord(this.note, this.chordType, this.properties);

  Chord(String chordString) {
    String propertiesRegex =
        ChordProperty.chordPropertyList.map((e) => e._getRegex()).join();
    RegExp chordExpression = RegExp(
        '^(?<note>[A-H])(?<accidental>#|b|##|bb)?(?<minor>m?)(?<extension>$propertiesRegex)(?<base_part>\\/(?<base_note>[A-H])(?<base_accidental>#|b|##|bb)?)?\$');
    RegExpMatch? match = chordExpression.firstMatch(chordString);
    assert(match != null);
    note = Note.fromString(
        match!.namedGroup('note')! + match.namedGroup('accidental')!);
    chordType =
        match.namedGroup('minor') == 'm' ? ChordType.minor : ChordType.major;
    // print(match.gr);
    properties = ChordProperty.chordPropertyList
        .where((element) => (match.namedGroup(element.identifier) ?? '') != '')
        .toList();
  }

  Set<int> getPitches() {
    Set<int> pitchOffsets = {0};
    if (chordType == ChordType.major) {
      pitchOffsets.add(4);
      pitchOffsets.add(7);
    } else if (chordType == ChordType.minor) {
      pitchOffsets.add(3);
      pitchOffsets.add(7);
    }
    for (var property in properties) {
      pitchOffsets.addAll(property.pitchOffsets);
    }
    for (var property in properties) {
      pitchOffsets.removeAll(property.toRemovePitchOffsets);
    }
    return pitchOffsets;
  }

  @override
  String toString() {
    return '$note ${chordType == ChordType.major ? 'Major' : 'Minor'} ${properties.join(' ')}';
  }
}

class ChordProperty {
  final String fullName;
  final String symbol;
  final String identifier;
  final Set<int> pitchOffsets;
  final Set<int> toRemovePitchOffsets;

  ChordProperty(this.fullName, this.symbol, this.identifier, this.pitchOffsets,
      this.toRemovePitchOffsets);

  static List<ChordProperty> chordPropertyList = [
    ChordProperty('Fifth', '5', 'i5', {}, {3, 4}),
    ChordProperty('Sixth', '6', 'i6', {9}, {}),
    ChordProperty('Seventh', '7', 'i7', {10}, {}),
    ChordProperty('Major Seventh', 'maj7', 'maj7', {11}, {}),
    ChordProperty('Major Seventh', 'M7', 'M7', {11}, {}),
    ChordProperty('Ninth', '9', 'i9', {14}, {}),
    ChordProperty('Eleventh', '11', 'i11', {17}, {}),
    ChordProperty('Thirteenth', '13', 'i13', {21}, {}),
    ChordProperty('Suspended', 'sus', 'susd', {5}, {3, 4}),
    ChordProperty('Suspended Two', 'sus2', 'sus2', {2}, {3, 4}),
    ChordProperty('Suspended Four', 'sus4', 'sus4', {5}, {3, 4}),
  ];

  String _getRegex() {
    return '(?<$identifier>$symbol)?';
  }

  @override
  String toString() {
    return fullName;
  }
}

/// A value representing the different types of chords.
enum ChordType {
  major,
  minor,
  augmented,
  diminished,
}

class Note {
  late WhiteNote whiteNote;
  late int offsetFromWhiteNote;

  Note(this.whiteNote, this.offsetFromWhiteNote);

  Note.fromString(String noteString) {
    RegExpMatch? match = RegExp(r'^([A-G])([#b]{0,2})$').firstMatch(noteString);
    assert(match != null);
    whiteNote = WhiteNote.values.firstWhere(
        (note) => note.toString() == 'WhiteNote.' + match!.group(1)!);
    offsetFromWhiteNote = {
      'bb': -2,
      'b': -1,
      '': 0,
      '#': 1,
      '##': 2,
    }[match!.group(2)!]!;
  }

  @override
  String toString() {
    return {
          WhiteNote.C: 'C',
          WhiteNote.D: 'D',
          WhiteNote.E: 'E',
          WhiteNote.F: 'F',
          WhiteNote.G: 'G',
          WhiteNote.A: 'A',
          WhiteNote.B: 'B',
        }[whiteNote]! +
        ' ' +
        {
          -2: 'Double Flat ',
          -1: 'Flat ',
          0: ' ',
          1: 'Sharp ',
          2: 'Double Sharp ',
        }[offsetFromWhiteNote]!;
  }
}

/// A value representing a note.
enum WhiteNote {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
}
