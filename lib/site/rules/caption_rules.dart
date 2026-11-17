/// How much a person may tell the caption writer, and what it gives back. The same limits the website's `suggest-caption` enforces.
const int ideaMin = 3;
const int ideaMax = 300;
const int ideaContextMax = 100;
const int ideasMax = 3;

/// Is this enough to ask with (after trimming and squeezing the spaces)?
bool ideaIsEnough(String idea) {
  final n = idea.replaceAll(RegExp(r'\s+'), ' ').trim().length;
  return n >= ideaMin && n <= ideaMax;
}

/// The note shown with every set of ideas: they come from an AI, from what the person typed, and are theirs to read and change before posting.
const String aiNote = 'These ideas are written by an AI from what you type here. Read them and change them before you post.';
