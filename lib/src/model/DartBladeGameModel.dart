part of modelLib;

class DartBladeGameModel{

  DartbladeGameController _controller;

  DartBladeGameModel(this._controller);

  bool _levelWon;
  bool _levelLost;
  int _currentLevel;
  String levelSecret;

  Blade _player;

  Level _level;

  int get currentLevel => _currentLevel;

  Future<bool> loadLevel(int lvln) async{

   if (!await LoadingLevel.generateLevelFromJSON(lvln)) return false;

    _currentLevel = LoadingLevel._levelNumber;
    levelSecret = LoadingLevel._levelSecret;
    return true;
  }


}