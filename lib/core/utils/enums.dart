class Enums {
  static Map<String, List<String>> enums = {};

  static void setEnums(Map<String, List<String>> newEnums) {
    enums = newEnums;
  }

  static List<String>? getEnum(String key) {
    return enums[key];
  }
}
