import 'sorting_strategy.dart';
import '../models/task.dart';

class SortByPriority implements SortingStrategy {
  @override
  List<Task> sort(List<Task> tasks) {
    tasks.sort((a, b) {
      const priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3};
      return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    });
    return tasks;
  }
}
