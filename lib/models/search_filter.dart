class SearchFilter {
  final String? query; final String? authorId; final DateTime? dateFrom;
  final DateTime? dateTo; final List<String> tags; final bool onlyWithComments;
  final bool onlyUncompleted; final bool includeShared; final bool includePersonal;
  final String? notebookId;
  const SearchFilter({this.query, this.authorId, this.dateFrom, this.dateTo,
    this.tags = const [], this.onlyWithComments = false, this.onlyUncompleted = false,
    this.includeShared = true, this.includePersonal = true, this.notebookId});
  SearchFilter copyWith({String? query, String? authorId, DateTime? dateFrom,
    DateTime? dateTo, List<String>? tags, bool? onlyWithComments, bool? onlyUncompleted,
    bool? includeShared, bool? includePersonal, String? notebookId}) =>
      SearchFilter(query: query ?? this.query, authorId: authorId ?? this.authorId,
        dateFrom: dateFrom ?? this.dateFrom, dateTo: dateTo ?? this.dateTo,
        tags: tags ?? this.tags, onlyWithComments: onlyWithComments ?? this.onlyWithComments,
        onlyUncompleted: onlyUncompleted ?? this.onlyUncompleted,
        includeShared: includeShared ?? this.includeShared,
        includePersonal: includePersonal ?? this.includePersonal,
        notebookId: notebookId ?? this.notebookId);
}
