class Score {
  final int questionId;
  final int timeTaken;
  final int isCorrect;

  Score(this.questionId, this.timeTaken, this.isCorrect);

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'questionId': this.questionId,
      'timeTaken': this.timeTaken,
      'isCorrect': this.isCorrect,
    } as Map<String, dynamic>;
  }
}
