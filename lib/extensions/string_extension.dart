extension StringExtension on String {
  String firstLetterCap() {
    return (this == null || isEmpty)
        ? this
        : "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
