part of modelLib;

class DartBladeGameModel{

  bool _levelWon = false;
  bool _levelLost = false;
  int _currentLevel = -1;
  String _levelSecret;

  Blade _player;

  Level _level;

  Map levelSecrets = {
    0: "sehrgeheim",
    1: "abc",
    2: "abe",
    3: "js2"
  };

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

  void setLevelLost(){
    _levelLost = true;
  }

  List<List<TileTypes>> getMap() => _level._getLevelTypes();

  Future<bool> loadLevelInModel(int levelNumber) async {
    _player = null;
    _level = null;
    if(!await LoadingLevel.getLevelDataFromJSON(levelNumber)) return false;
    _currentLevel = LoadingLevel._levelNumber;
    _levelSecret = getLevelSecretFromLevelNumber(_currentLevel);
    _level = new Level(LoadingLevel._levelStructur, LoadingLevel._levelNumber, LoadingLevel._levelSecret, LoadingLevel._size_x, LoadingLevel._size_y, this);
    return true;
  }


  String getLevelSecretFromLevelNumber(int currentLevel) {
    if(levelSecrets.containsKey(currentLevel)){
      return levelSecrets[currentLevel];
    }
  }
  int getLevelNumberFromLevelSecret(String levelSecret) {
    if(levelSecrets.containsValue(levelSecret)){
      var key = levelSecrets.keys.firstWhere((k) => levelSecrets[k] == "$levelSecret", orElse: () => null);
      return key;
    }else{
      return -1;
    }
  }



}