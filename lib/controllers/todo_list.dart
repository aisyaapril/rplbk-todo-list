import 'observer.dart';
import '../models/task.dart';
import '../strategy/sorting_strategy.dart';

class ToDoList {
  List<Task> tasks = [];
  List<Observer> observers = [];

  void addObserver(Observer observer) {
    observers.add(observer);
  }

  void removeObserver(Observer observer) {
    observers.remove(observer);
  }

  void notifyObservers(String message) {
    for (var observer in observers) {
      observer.update(message);
    }
  }

  void addTask(Task task) {
    tasks.add(task);
    notifyObservers("Task '${task.name}' added.");
  }

  void removeTask(String taskName) {
    tasks.removeWhere((task) => task.name == taskName);
    notifyObservers("Task '$taskName' removed.");
  }

  void editTask(String oldName, String newName, String newPriority) {
    var task = tasks.firstWhere((task) => task.name == oldName);
    task.name = newName;
    task.priority = newPriority;
    notifyObservers(
        "Task '$oldName' edited to '$newName' with priority '$newPriority'.");
  }
}

class ToDoListWithStrategy extends ToDoList {
  SortingStrategy? sortingStrategy;

  void setSortingStrategy(SortingStrategy strategy) {
    sortingStrategy = strategy;
  }

  List<Task> getSortedTasks() {
    if (sortingStrategy == null) return tasks;
    return sortingStrategy!.sort(tasks);
  }
}
