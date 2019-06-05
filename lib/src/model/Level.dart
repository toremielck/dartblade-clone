part of modelLib;

class Level {

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
  static String _levelStructur;

  String type;

  Element levelDiv;

  Level(String levelStructur, this._levelNumber, this._levelSecret, this._size_x, this._size_y, this._model) {
    _initTiles();
    writeLevelStructure(levelStructur);
  }

  List<List<Tile>> _levelTiles = new List<List<Tile>>();

  // Die JSON-Level-Datei abholen und den Inhalt der JSON-Datei in die Level-Variablen schreiben.
  // Dann werden die einzelnen Symbole der level.json Datei in HTML-Divs umgesetzt
  // mit Hilfe der writeLevelStrctureToHTML()-Methode. Dies erfolgt alles asynchron.
  // Deshalb auch der Rückhabewert Future<bool>

  /*
  static Future<bool> getLevelDataFromJSON(int levelNum) async {

   if(levelNum == null){
     print("Level.getLevelDataFromJSON() levelNum: is null");
     return false;
   }

    try {

      // Wenn es auf dem mylab-Server laufen soll muss der Pfad der JSON-Levels anders
      // angegeben werden:
      // await HttpRequest.getString("/ss2019/team-5e/levels/level_${levelNum}.json").then((String requestResult)
    //  await HttpRequest.getString("/levels/level_${levelNum}.json").then((String requestResult) {

      String jsonCode = await HttpRequest.getString("/levels/level_${levelNum}.json");

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

      _initTiles();
      await writeLevelStructure(_levelStructur);

      return true;


  }

  */

  List<List<TileTypes>> _getLevelTypes(){
    List<List<TileTypes>> returnList = new List<List<TileTypes>>();

    for(int y = 0; y < _size_y; y++){
      returnList.add(new List());
      for(int x = 0; x <_size_x; x++){
        final tile = _levelTiles[y][x];

        if(tile._specialTile != null){
          if(tile._specialTile is GameOverTile){
            returnList[y].add(TileTypes.GAMEOVERTILE);
          }
          else if(tile._specialTile is SpinTile){
            returnList[y].add(TileTypes.SPINTILE);
          }
          else if(tile._specialTile is GoalTile){
            returnList[y].add(TileTypes.GOALTILE);
          }
          else if(tile._specialTile is GroundTile){
            returnList[y].add(TileTypes.GROUNDTILE);
          }
        }
      }
    }
    return returnList;
  }

  void writeLevelStructure(String levelStructur) {


    List<String> levelRows = levelStructur.split(LoadingLevel.SEPERATOR);

    try{
      for (int y = 0; y < _size_y; y++) {

        // Neue tr (row) ins HTML einfügen für den line-break
   //   _view.generateTR();

        String line = levelRows[y];
        for (int x = 0; x < _size_x; x++) {

          switch (line[x]) {
            case LoadingLevel.GAMEOVERTILE:
            // Tile in HTML-Struktur schreiben
       //       _view.generateTdgameoverElement();
              // Tile in Model-Tile-Liste einfügen
              _levelTiles[y][x]._specialTile = new GameOverTile(x, y, _model);
              break;
            case LoadingLevel.GROUNDTILE:
            // Tile in HTML-Struktur schreiben
         //     var tileDiv = new DivElement();
          //    tileDiv.className = "td normal-tile";
            //  tileDiv.setAttribute("tileType", "normal-tile");
            //  levelDiv.children.add(tileDiv);
              // Tile in Model-Tile-Liste einfügen
              _levelTiles[y][x]._specialTile = new GroundTile(x, y, _model);
              break;
            case LoadingLevel.SPINTILE:
            // Tile in HTML-Struktur schreiben
       //       var tileDiv = new DivElement();
        //      tileDiv.className = "td spin-tile";
         //     tileDiv.setAttribute("tileType", "spin-tile");
          //    levelDiv.children.add(tileDiv);
              // Tile in Model-Tile-Liste einfügen
              _levelTiles[x][y]._specialTile = new SpinTile(x, y, _model);
              break;
            case LoadingLevel.GOALTILE:
            // Tile in HTML-Struktur schreiben
      //        var tileDiv = new DivElement();
       //       tileDiv.className = "td goal-tile";
        //      tileDiv.setAttribute("tileType", "goal-tile");
         //     levelDiv.children.add(tileDiv);
              // Tile in Model-Tile-Liste einfügen
              _levelTiles[x][y]._specialTile = new GoalTile(x, y, _model);
              break;
            default:
              break;
          }
        }
      }
    }catch(e){
      print("writeLevelStructur(): $e ");
      return;
    }

  }

  void _initTiles(){
    if(_size_x == null || _size_y == null){
      print("initTiles(): keine größe gefunden");
    }
    for(int y = 0; y < _size_y; y++){
      List<Tile> list = new List();
      for(int x = 0; x < _size_x; x++){
        list.add(new Tile(x, y));
      }
      _levelTiles.add(list);
    }
  }
}