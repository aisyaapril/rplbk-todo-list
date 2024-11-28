import '../models/task.dart';

abstract class SortingStrategy {
  List<Task> sort(List<Task> tasks);
}
