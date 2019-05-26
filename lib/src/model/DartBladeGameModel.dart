part of modelLib;

class DartBladeGameModel{

  DartbladeGameController _controller;

  DartBladeGameModel(this._controller);

  bool _levelWon;
  bool _levelLost;
  int _currentLevel;
  String _levelSecret;

  Blade _player;

  Level _level;

}