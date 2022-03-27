/*
https://github.com/yomed/frettable

The MIT License (MIT)

Copyright (c) 2015 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

bool frettable(List<int> frets) {
  const totalFingers = 4;
  List<List<Map<String, int>>> usedFingers = [];

  for (int string = 0; string < frets.length; string++) {
    int fret = frets[string];
    List<Map<String, int>> newGroup = [];
    Map<String, int> note = {'fret': fret, 'string': string};

    if (fret > 0) {
      bool needNewGroup = true;

      // first try to add note to one of current finger groups
      for (var fingerGroup in usedFingers) {
        int groupFret = fingerGroup[0]['fret']!;
        int groupString = fingerGroup[0]['string']!;

        // barre if fret number matches where finger is fretted on a previous note
        // but dont barre when:
        // * on top 5 strings and next note in sequence is a lower fret
        // * on 5th note and third group, and last note would create fourth group
        if (fret == groupFret &&
            !(string < 5 && fret >= frets[string + 1]) &&
            !(string == 4 && frets[5] != fret && usedFingers.length == 3)) {
          // if the in between notes are on higher frets
          List<int> diff = frets.sublist(groupString + 1, string);
          if (diff.where((i) => (i >= fret)).length == diff.length) {
            // then barre this note with the rest of this finger group
            fingerGroup.add(note);
            needNewGroup = false;
          }
        }
      }

      // otherwise create new group
      if (needNewGroup) {
        newGroup.add(note);
        usedFingers.add(newGroup);
      }
    }
  }

  return usedFingers.length <= totalFingers;
}

int frettableDifficulty(List<int> frets) {
  List<List<Map<String, int>>> usedFingers = [];
  int difficulty = 0;

  for (int string = 0; string < frets.length; string++) {
    int fret = frets[string];
    List<Map<String, int>> newGroup = [];
    Map<String, int> note = {'fret': fret, 'string': string};

    if (fret > 0) {
      bool needNewGroup = true;

      // first try to add note to one of current finger groups
      for (var fingerGroup in usedFingers) {
        int groupFret = fingerGroup[0]['fret']!;
        int groupString = fingerGroup[0]['string']!;

        // barre if fret number matches where finger is fretted on a previous note
        // but dont barre when:
        // * on top 5 strings and next note in sequence is a lower fret
        // * on 5th note and third group, and last note would create fourth group
        if (fret == groupFret &&
            !(string < 5 && fret >= frets[string + 1]) &&
            !(string == 4 && frets[5] != fret && usedFingers.length == 3)) {
          // if the in between notes are on higher frets
          List<int> diff = frets.sublist(groupString + 1, string);
          if (diff.where((i) => (i >= fret)).length == diff.length) {
            // then barre this note with the rest of this finger group
            fingerGroup.add(note);
            needNewGroup = false;
          }
        }
      }

      // otherwise create new group
      if (needNewGroup) {
        newGroup.add(note);
        usedFingers.add(newGroup);
        if (newGroup.length == 1) {
          difficulty++;
        } else {
          difficulty += 2;
        }
      }
    }
  }

  return difficulty;
}
