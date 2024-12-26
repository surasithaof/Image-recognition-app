class User {
  String name;
  final List<double> vectorList;
  User(this.name, this.vectorList);

  User copyWith({List<double>? list}) {
    return User(name, list ?? vectorList);
  }
}
