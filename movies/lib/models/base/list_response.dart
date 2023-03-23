class ListResponse {
  final List list;
  final int page;
  final int total;
  final int pages;

  ListResponse({
    required this.list,
    required this.page,
    required this.total,
    required this.pages,
  });
}