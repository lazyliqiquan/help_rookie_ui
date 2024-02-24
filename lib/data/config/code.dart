class WebSupportCode {
  static const List<String> supportLanguage = [
    'C',
    'C++',
    'Java',
    'Golang',
    'Python',
    'C#',
    'JavaScript',
    'TypeScript',
    'PHP',
    'Rust',
  ];
  static const Map<String, String> _suffixFileMap = {
    'c': 'C',
    'cpp': 'C++',
    'cc': 'C++',
    'java': 'Java',
    'go': 'Golang',
    'py': 'Python',
    'cs': 'C#',
    'js': 'JavaScript',
    'ts': 'TypeScript',
    'php': 'PHP',
    'rs': 'Rust',
  };

  static String? fileToLang(String fileSuffix) {
    return _suffixFileMap[fileSuffix];
  }

  static List<String> langToFile(String lang) {
    List<String> res = [];
    _suffixFileMap.forEach((key, value) {
      if (value == lang) {
        res.add(key);
      }
    });
    return res;
  }
}
