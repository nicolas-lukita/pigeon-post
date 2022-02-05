class Language {
  String name;
  String code;
  bool isRecent;
  bool isDownloaded;
  bool isDownloadable;

  Language(
      {required this.code,
      required this.name,
      required this.isRecent,
      required this.isDownloaded,
      required this.isDownloadable});
}
