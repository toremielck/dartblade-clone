part of modelLib;

class LoadingLevel{
 static int _levelNumber = -1;
 static String _levelSecret = null;
 static int _size_x;
 static int _size_y;

 static String _levelStructur = null;

  // Dekodierung der LevelStruktur
  static const EDGE = "X";
  static const GROUND = "#";
  static const SEPARATOR = "|";

  static Future<bool> generateLevelFromJSON(int lvln) async{
    if(lvln == null){
      print("getlevle(lvln) is null");
    }
    try{
      String json = await HttpRequest.getString("/levels/level_${lvln}.json");

      if(json == null) {
        throw new Exception("level_${lvln} not found");
      }
      final allData = jsonDecode(json);

      _levelNumber = allData["levelNumber"];
      _levelSecret = allData["levelSecret"];
      _size_x = allData["size_x"];
      _size_y = allData["size_y"];
      _levelStructur = allData["levelStructur"];

      if(_levelNumber == null){
        throw new Exception("Level kann nicht gelesen werden!");
      }

    } catch(e,  stackTrace){
        print("getLevel(): ${e}");
        print(stackTrace);
    }
    return true;
  }

}