part of modelLib;

class Level {

  /// Verknüfpung zum Model
  DartBladeGameModel _model;

  /// Verknüpfung zur View
  DartBladeGameView _view;
  Blade _player;

  /// Position des Levels
  int _position_x;
  int _position_y;

  /// Größe des Levels
 int _size_x;
 int _size_y;

 /// Nummer des Levels
 int _levelNumber;

 /// Das Secret des Levels
 String _levelSecret;

 /// Struktur des Levels kodiert als einzelne Tiles
  static String _levelStructur;

  String type;

  Element levelDiv;

  Level(String levelStructur, this._levelNumber, this._levelSecret, this._size_x, this._size_y, this._model) {
    _initTiles();
    writeLevelStructure(levelStructur);
  }
  List<List<Tile>> _levelTiles = new List<List<Tile>>();

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

        String line = levelRows[y];
        for (int x = 0; x < _size_x; x++) {

          switch (line[x]) {
            case LoadingLevel.GAMEOVERTILE:
              _levelTiles[y][x]._specialTile = new GameOverTile(x, y, _model);
              break;
            case LoadingLevel.GROUNDTILE:
              _levelTiles[y][x]._specialTile = new GroundTile(x, y, _model);
              break;
            case LoadingLevel.SPINTILE:
              _levelTiles[y][x]._specialTile = new SpinTile(x, y, _model);
              break;
            case LoadingLevel.GOALTILE:
              _levelTiles[y][x]._specialTile = new GoalTile(x, y, _model);
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