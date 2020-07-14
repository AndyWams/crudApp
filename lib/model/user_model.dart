class Contact {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colTitle = 'title';

  Contact({this.id, this.name, this.title});

  int id;
  String name;
  String title;

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    title = map[colTitle];
  }
  toString() {
    return '{$id, $name, $title}';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colTitle: title};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
