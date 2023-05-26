enum HabitState {
  enabled('enabled'),
  archieved('archieved');

  const HabitState(this.key);
  final String key;

  static HabitState parse(String key) {
    return HabitState.values.firstWhere(
      (e) => e.key == key,
      orElse: () => HabitState.enabled,
    );
  }
}
