class Serie {
  String id;
  String name;
  int votes;
  int type;

  Serie(
      {required this.id,
      required this.name,
      required this.votes,
      required this.type});

  factory Serie.fromMap(Map<String, dynamic> obj) => Serie(
      id: obj['id'], name: obj['name'], votes: obj['vote'], type: obj['type']);
}
