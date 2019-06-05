part of modelLib;

class DartBladeGameModel{



  bool _levelWon = false;
  bool _levelLost = false;
  int _currentLevel = -1;
  String _levelSecret;

  Blade _player;

  Level _level;

  DartbladeGameController _controller;

  DartBladeGameModel(this._controller);


  // return tur if player success level, else false;
  bool get levelWon => _levelWon;

  // return true if player failed level, else false;
  bool get levelFail => _levelLost;

  // return current levelNumber
  int get levelNumber => _currentLevel;

  // return current player spin
  int get playerSpin => _player.spin;

  void setLevelWon(){
    _levelWon = true;
  }

  void setLevelFail(){
    _levelLost = true;
  }

  List<List<TileTypes>> getMap() => _level._getLevelTypes();

  Future<bool> loadLevelInModel(int levelNumber) async {
    _player = null;
    if(!await LoadingLevel.getLevelDataFromJSON(levelNumber)) return false;
    _currentLevel = LoadingLevel._levelNumber;

    _level = new Level(LoadingLevel._levelStructur, LoadingLevel._levelNumber, LoadingLevel._levelSecret, LoadingLevel._size_x, LoadingLevel._size_y, this);
    return true;
  }


}