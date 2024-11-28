abstract class Observer {
  void update(String message);
}

class TaskObserver implements Observer {
  @override
  void update(String message) {
    print("Notification: $message");
  }
}
