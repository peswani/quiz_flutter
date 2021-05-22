class Notes {
  final int? id;
  final String category;
  final int duration;
  final String note;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Notes({
    this.id,
    required this.category,
    required this.duration,
    required this.note,
  });

  Notes copyWith({
    int? id,
    required String category,
    required int duration,
    required String note,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (category == null || identical(category, this.category)) &&
        (duration == null || identical(duration, this.duration)) &&
        (note == null || identical(note, this.note))) {
      return this;
    }

    return new Notes(
      id: id ?? this.id,
      category: category,
      duration: duration,
      note: note,
    );
  }

  @override
  String toString() {
    return 'Notes{id: $id, category: $category, duration: $duration, note: $note}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notes &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          category == other.category &&
          duration == other.duration &&
          note == other.note);

  @override
  int get hashCode =>
      id.hashCode ^ category.hashCode ^ duration.hashCode ^ note.hashCode;

  factory Notes.fromMap(Map<String, dynamic> map) {
    return new Notes(
      id: map['id'] as int,
      category: map['category'] as String,
      duration: map['duration'] as int,
      note: map['note'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'category': this.category,
      'duration': this.duration,
      'note': this.note,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
