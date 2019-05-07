part of modelLib;

class LoadingLevel{
  int _levelNumber = -1;
  String _levelSecret = null;
  int _size_x;
  int _size_y;

  String _levelStructur = null;

  // Dekodierung der LevelStruktur
  static const EDGE = "X";
  static const GROUND = "#";
  static const SEPARATOR = "|";

  Future<bool> getLevel(int lvln) async{
    if(lvln == null){
      print("getlevle(lvln) is null");
    }
    try{
      String json = await HttpRequest.getString("levels/level_${lvln}.json");

      if(json == null) {
        throw new Exception("level_${lvln} not found");
      }
      final allData = jsonDecode(json);

      _levelNumber = allData["levelNumber"];
      _levelSecret = allData["levelSecret"];
      _size_x = allData["size_x"];
      _size_y = allData["size_y"];
      _levelStructur = allData["levelStructur"];



    } catch(e){
        print("getLevel(): ${e}");
    }
    return true;
  }
}