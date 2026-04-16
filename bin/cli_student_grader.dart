import 'dart:io';
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
