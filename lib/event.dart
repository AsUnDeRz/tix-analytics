class TixEvent {
  String name;
  dynamic values;

  TixEvent(this.name, this.values);
}

class TixError {
  String name;
  dynamic error;
  dynamic stackTrace;

  TixError(this.name, this.error, this.stackTrace);
}
