extension StringHelpers on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeAll() {
    return split(" ").map((word) => word.capitalize()).join(" ");
  }
}