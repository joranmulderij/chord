Note: This package isn't finished yet. Many of the core features are still under development.

## Features

* Parsing and anlyzing chords from their string representations.
* Generating fingerings and tabs for fretted string instruments like guitar or ukulele.
* Generating the list of pitches that make up a chord.
* Can be used in combination of the [flutter_guitar_tabs](https://pub.dev/packages/flutter_guitar_tabs) and [keyboard_chord_charts](https://pub.dev/packages/keyboard_chord_charts) packages.

## Usage

```dart
// Create a [Chord] object
Chord chord = Chord('C#m7sus2');
// Get all information about the chord.
print(chord); // "C Sharp  Minor Seventh Suspended Two"
print(chord.getPitches()); // {0, 7, 10, 2}
print(chord.note); // C Sharp
print(chord.chordType); // ChordType.minor
```

## Additional information

TODO's

* Guitar fretting generation
* Unit tests
* Documentation

This package is still under development, and breaking changes may happen. Many of the essential features aren't developed yet. If you find anything unexpected or think you have a suggestion for anything, submit an issue or pr. If you like this package, please give it a github star.
