class TixEvent extends TixBase {
  dynamic values;

  @override
  String get name => super.name == null ? runtimeType.toString() : super.name;

  TixEvent();

  TixEvent.click(this.values);
}

class TixError extends TixBase {
  dynamic error;
  dynamic stackTrace;

  TixError();

  @override
  String get name => super.name == null ? runtimeType.toString() : super.name;
}

abstract class TixBase {
  String name;
}
