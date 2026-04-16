import 'dart:io';

const String appTitle = "Student Grader v1.0";

final Set<String> availableSubjects = {
  "Math",
  "English",
  "Science",
  "History"
};

void main() {
  var students = <Map<String, dynamic>>[];
  var isRunning = true;

  do {
    print("""
===== $appTitle =====

1. Add Student
2. Record Score
3. Add Bonus Points
4. Add Comment
5. View All Students
6. View Report Card
7. Class Summary
8. Exit
""");

    stdout.write("Choose an option: ");
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addStudent(students);
        break;

      case '2':
        recordScore(students);
        break;

      case '3':
        addBonus(students);
        break;

      case '4':
        addComment(students);
        break;

      case '5':
        viewAllStudents(students);
        break;

      case '6':
        viewReportCard(students);
        break;

      case '7':
        classSummary(students);
        break;

      case '8':
        print("Exiting $appTitle...");
        isRunning = false;
        break;

      default:
        print("Invalid option. Try again.");
    }

    print("");
  } while (isRunning);
}

void addStudent(List<Map<String, dynamic>> students) {
  stdout.write("Enter student name: ");
  var name = stdin.readLineSync();

  var student = {
    "name": name,
    "scores": <int>[],
    "subjects": {...availableSubjects},
    "bonus": null,
    "comment": null,
  };

  students.add(student);

  print("Student ${student["name"]} added successfully!");
}

void recordScore(List<Map<String, dynamic>> students) {
  if (students.isEmpty) {
    print("No students available.");
    return;
  }

  print("\nSelect a student:");
  for (int i = 0; i < students.length; i++) {
    print("${i + 1}. ${students[i]["name"]}");
  }

  stdout.write("Enter student number: ");
  var studentIndex = int.parse(stdin.readLineSync()!) - 1;

  if (studentIndex < 0 || studentIndex >= students.length) {
    print("Invalid student selection.");
    return;
  }

  var student = students[studentIndex];

  print("Available subjects:");
  for (var subject in student["subjects"]) {
    print("- $subject");
  }

  stdout.write("Enter subject name: ");
  var subjectName = stdin.readLineSync();

  if (!student["subjects"].contains(subjectName)) {
    print("Subject not found.");
    return;
  }

  var score = -1;

  while (score < 0 || score > 100) {
    stdout.write("Enter score for $subjectName (0-100): ");
    score = int.tryParse(stdin.readLineSync() ?? "") ?? -1;

    if (score < 0 || score > 100) {
      print("Invalid score. Please enter a value between 0 and 100.");
    }
  }

  student["scores"].add(score);

  print("Score $score added for ${student["name"]} in $subjectName.");
}

void addBonus(List<Map<String, dynamic>> students) {
  if (students.isEmpty) {
    print("No students available.");
    return;
  }

  for (int i = 0; i < students.length; i++) {
    print("${i + 1}. ${students[i]["name"]}");
  }

  stdout.write("Choose a student: ");
  var index = int.parse(stdin.readLineSync()!) - 1;

  if (index < 0 || index >= students.length) {
    print("Invalid student selection.");
    return;
  }

  var student = students[index];

  stdout.write("Enter bonus points (1-10): ");
  var bonusValue = int.parse(stdin.readLineSync()!);

  if (student["bonus"] == null) {
    student["bonus"] ??= bonusValue;
    print("Bonus added successfully.");
  } else {
    print("${student["name"]} already has bonus points.");
  }
}

void addComment(List<Map<String, dynamic>> students) {
  if (students.isEmpty) {
    print("No students available.");
    return;
  }

  for (int i = 0; i < students.length; i++) {
    print("${i + 1}. ${students[i]["name"]}");
  }

  stdout.write("Choose a student: ");
  var index = int.parse(stdin.readLineSync()!) - 1;

  if (index < 0 || index >= students.length) {
    print("Invalid student selection.");
    return;
  }

  stdout.write("Enter teacher comment: ");
  var comment = stdin.readLineSync();

  students[index]["comment"] = comment;

  print("Comment added for ${students[index]["name"]}.");
}

double calculateAverage(Map<String, dynamic> student) {
  List<int> scores = List<int>.from(student["scores"]);

  if (scores.isEmpty) {
    return 0;
  }

  var sum = 0;

  for (var score in scores) {
    sum += score;
  }

  var rawAverage = sum / scores.length;
  var finalAverage = rawAverage + (student["bonus"] ?? 0);

  if (finalAverage > 100) {
    finalAverage = 100;
  }

  return finalAverage;
}

String calculateGrade(double average) {
  if (average >= 90) {
    return "A";
  } else if (average >= 80) {
    return "B";
  } else if (average >= 70) {
    return "C";
  } else if (average >= 60) {
    return "D";
  } else {
    return "F";
  }
}

void viewAllStudents(List<Map<String, dynamic>> students) {
  if (students.isEmpty) {
    print("No students available.");
    return;
  }

  print("\nAll Students:");

  for (var student in students) {
    var tags = [
      student["name"],
      "${student["scores"].length} scores",
      if (student["bonus"] != null) "⭐ Has Bonus",
    ];

    print(tags.join(" | "));
  }
}

void viewReportCard(List<Map<String, dynamic>> students) {
  if (students.isEmpty) {
    print("No students available.");
    return;
  }

  for (int i = 0; i < students.length; i++) {
    print("${i + 1}. ${students[i]["name"]}");
  }

  stdout.write("Choose a student: ");
  var index = int.parse(stdin.readLineSync()!) - 1;

  if (index < 0 || index >= students.length) {
    print("Invalid student selection.");
    return;
  }

  var student = students[index];

  var average = calculateAverage(student);
  var grade = calculateGrade(average);

  String commentDisplay =
      student["comment"]?.toUpperCase() ?? "NO COMMENT PROVIDED";

  String feedback = switch (grade) {
    "A" => "Outstanding performance!",
    "B" => "Good work, keep it up!",
    "C" => "Satisfactory. Room to improve.",
    "D" => "Needs improvement.",
    "F" => "Failing. Please seek help.",
    _ => "Unknown grade."
  };

  print("""
╔══════════════════════════════╗
║         REPORT CARD         ║
╠══════════════════════════════╣
║ Name: ${student["name"]}
║ Scores: ${student["scores"]}
║ Bonus: +${student["bonus"] ?? 0}
║ Average: ${average.toStringAsFixed(1)}
║ Grade: $grade
║ Comment: $commentDisplay
╚══════════════════════════════╝
Feedback: $feedback
""");
}

void classSummary(List<Map<String, dynamic>> students) {
  if (students.isEmpty) {
    print("No students available.");
    return;
  }

  var totalAverage = 0.0;
  var highestAverage = 0.0;
  var lowestAverage = 100.0;
  var passCount = 0;

  Set<String> gradeSet = {};

  for (var student in students) {
    var average = calculateAverage(student);
    var grade = calculateGrade(average);

    totalAverage += average;

    if (average > highestAverage) {
      highestAverage = average;
    }

    if (average < lowestAverage) {
      lowestAverage = average;
    }

    if (student["scores"].isNotEmpty && average >= 60) {
      passCount++;
    }

    gradeSet.add(grade);
  }

  var classAverage = totalAverage / students.length;

  var summaryLines = [
    for (var student in students)
      "${student["name"]}: ${calculateAverage(student).toStringAsFixed(1)}"
  ];

  print("""
===== CLASS SUMMARY =====
Total Students: ${students.length}
Class Average: ${classAverage.toStringAsFixed(1)}
Highest Average: ${highestAverage.toStringAsFixed(1)}
Lowest Average: ${lowestAverage.toStringAsFixed(1)}
Passing Students: $passCount
Unique Grades: $gradeSet

Student Averages:
${summaryLines.join("\n")}
""");
}
