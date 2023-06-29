
class MastersDataModelClass {
  MastersDataModelClass({
      String? id,
      String? name,}){
    _id = id;
    _name = name;
}

  MastersDataModelClass.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
  }
  String? _id;
  String? _name;
MastersDataModelClass copyWith({  String? id,
  String? name,
}) => MastersDataModelClass(  id: id ?? _id,
  name: name ?? _name,
);
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    return map;
  }

  static List<MastersDataModelClass> fromJsonList(dynamic jsonList) {
    final catList = <MastersDataModelClass>[];
    if (jsonList == null) return catList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        catList.add(
          MastersDataModelClass.fromJson(json),
        );
      }
    }
    return catList;
  }

}