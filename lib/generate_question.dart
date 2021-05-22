class GenerateQuestions {
  static List<Questions> getQuestions(String category) {
    Questions q1 = Questions(
        "If soccer is called football in England, what is American football called in England?",
        category,
        "American football",
        ['American football', 'Combball', 'Handball', 'Touchdown']);
    Questions q2 = Questions("What is the largest country in the world?",
        category, "Russia", ['Russia', 'Canada', 'China', 'United States']);

    Questions q3 = Questions(
        "An organic compound is considered an alcohol if it has what functional group?",
        category,
        "Hydroxyl",
        ['Hydroxyl', 'Carbonyl', 'Alkyl', 'Aldehyde']);
    Questions q4 = Questions(
        "What is the 100th digit of Pi?", category, "9", ['9', '9', '7', '2']);
    Questions q5 = Questions(
        "A doctor with a PhD is a doctor of what?",
        category,
        "Philosophy",
        ['Philosophy', 'Psychology', 'Phrenology', 'Physical Therapy']);

    Questions q6 = Questions("What year did World War I begin?", category,
        "1914", ['1914', '1905', '1919', '1925']);
    Questions q7 = Questions(
        "What is isobutylphenylpropanoic acid more commonly known as?",
        category,
        "Ibuprofen",
        ['Ibuprofen', 'Morphine', 'Ketamine', 'Aspirin']);

    Questions q8 = Questions(
        "What state is the largest state of the United States of America?",
        category,
        "Alaska",
        ['Alaska', 'California', 'Texas', 'Washington']);
    Questions q9 = Questions("Which of these is a stop codon in DNA?", category,
        "TAA", ['TAA', 'ACT', 'ACA', 'GTA']);
    Questions q10 = Questions(
        "Which of these countries is NOT a part of the Asian continent?",
        category,
        "Suriname",
        ['Suriname', 'Georgia', 'Russia', 'Singapore']);

    return [q1, q2, q3, q4, q5, q6, q7, q8, q9, q10];
  }
}

class Questions {
  final String question;
  final String category;
  final String answer;
  final List<String> options;

  Questions(this.question, this.category, this.answer, this.options);
}
