part of modelLib;

class Level {

  static const SEPERATOR = "|";
  static const GAMEOVERTILE = "X";
  static const NORMALTILE = "#";
  static const SPINTILE = "~";

  Level(int levelNumber) {
    getLevelDataFromJSON(levelNumber);

  }

  // Verknüfpung zum Model
  DartBladeGameModel _model;

  // Verknüpfung zur View
  DartBladeGameView _view;

  // Position des Levels
  int _position_x;
  int _position_y;

  // Größe des Levels
  int _size_x;
  int _size_y;

  int _levelNumber;
  String _levelSecret;

  // Struktur des Levels kodiert als einzelne Tiles
  String _levelStructur;

  String type;


  List<List<Tile>> _levelTiles;


  // Die JSON-Level-Datei abholen und den Inhalt der JSON-Datei in die Level-Variablen schreiben.
  // Dann werden die einzelnen Symbole der level.json Datei in HTML-Divs umgesetzt
  // mit Hilfe der writeLevelStrctureToHTML()-Methode. Dies erfolgt alles asynchron.
  // Deshalb auch der Rückhabewert Future<bool>
  Future<bool> getLevelDataFromJSON(int levelNum) async {

    try {

      // Wenn es auf dem mylab-Server laufen soll muss der Pfad der JSON-Levels anders
      // angegeben werden:
      // await HttpRequest.getString("/ss2019/team-5e/levels/level_${levelNum}.json").then((String requestResult)
      await HttpRequest.getString("/levels/level_${levelNum}.json").then((String requestResult) {

      var levelData = jsonDecode(requestResult);



      _levelNumber = levelData["levelNumber"];
      _levelSecret = levelData["levelSecret"];
      _size_x = levelData["size_x"];
      _size_y = levelData["size_y"];
      _levelStructur = levelData["levelStructur"];

      });
      await writeLevelStructure(_levelStructur);
      return true;

    } catch (e) {
      print("getLevelDataFromJSON Error: ${e} | levelSecret: ${_levelSecret}");
      return false;
    }
  }

  Future<bool> writeLevelStructure(String levelStructur) async {
    // Das HTML-Element mit der id "level" auswählen und in Konstante abspeichern
    // um es mit den Tiles zu befüllen
    var levelDiv = _view.level;

    List<String> levelRows = levelStructur.split(SEPERATOR);

    for (int x = 0; x <= this._size_x; x++) {
      String line = levelRows[x];
      for (int y = 0; y <= this._size_y; y++) {
        switch (line[y]) {
          case GAMEOVERTILE:
          // Tile in HTML-Struktur schreiben
            var tileDiv = new DivElement();
            tileDiv.className = "td gameover-tile";
            tileDiv.setAttribute("tileType", "gameover-tile");
            levelDiv.children.add(tileDiv);
            // Tile in Model-Tile-Liste einfügen
            _levelTiles[x][y] = new Tile(x, y);
            break;
          case NORMALTILE:
          // Tile in HTML-Struktur schreiben
            var tileDiv = new DivElement();
            tileDiv.className = "td normal-tile";
            tileDiv.setAttribute("tileType", "normal-tile");
            levelDiv.children.add(tileDiv);
            // Tile in Model-Tile-Liste einfügen
            _levelTiles[x][y] = new Tile(x, y);
            break;
          case SPINTILE:
          // Tile in HTML-Struktur schreiben
            var tileDiv = new DivElement();
            tileDiv.className = "td spin-tile";
            tileDiv.setAttribute("tileType", "spin-tile");
            levelDiv.children.add(tileDiv);
            // Tile in Model-Tile-Liste einfügen
            _levelTiles[x][y] = new SpecialTile(x, y, _model);
            break;
          default:
            break;
        }
      }
    }
  }
}