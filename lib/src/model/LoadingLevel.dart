part of modelLib;

class LoadingLevel{


  static const SEPERATOR = "|";
  static const GAMEOVERTILE = "X";
  static const GROUNDTILE = "#";
  static const SPINTILE = "~";
  static const GOALTILE = "G";


  // Größe des Levels
  static int _size_x;
  static int _size_y;

  static int _levelNumber;
  static String _levelSecret;

  // Struktur des Levels kodiert als einzelne Tiles
  static String _levelStructur;

  // Die JSON-Level-Datei abholen und den Inhalt der JSON-Datei in die Level-Variablen schreiben.
  // Dann werden die einzelnen Symbole der level.json Datei in HTML-Divs umgesetzt
  // mit Hilfe der writeLevelStrctureToHTML()-Methode. Dies erfolgt alles asynchron.
  // Deshalb auch der Rückhabewert Future<bool>
  static Future<bool> getLevelDataFromJSON(int levelNum) async {

    if(levelNum == null){
      print("Level.getLevelDataFromJSON() levelNum: is null");
      return false;
    }

    try {

      // Wenn es auf dem mylab-Server laufen soll muss der Pfad der JSON-Levels anders
      // angegeben werden:

    //  String jsonCode = await HttpRequest.getString("/ss2019/team-5e/levels/level_${levelNum}.json");
      String jsonCode = await HttpRequest.getString("/ss2019/team-5e/levels/level_${levelNum}.json");

      var levelData = jsonDecode(jsonCode);

      _levelNumber = levelData["levelNumber"];
      _levelSecret = levelData["levelSecret"];
      _size_x = levelData["size_x"];
      _size_y = levelData["size_y"];
      _levelStructur = levelData["levelStructur"];
    }catch (e) {
      print("getLevelDataFromJSON Error: ${e} | levelSecret: ${_levelSecret}");
      return false;
    }
    return true;


  }
}