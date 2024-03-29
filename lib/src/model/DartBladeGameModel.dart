part of modelLib;

class DartBladeGameModel{

  bool _levelWon = false;
  bool _levelLost = false;
  int _currentLevel = -1;
  String _levelSecret;
  int gameoverTrigger = -1;

  /// Das Spieler-Objekt
  Blade _player;

  Level _level;

  /// Alle Level-Secrets gespeichert in einer Map zur späteren Abfrage
  Map levelSecrets = {
    0: "apfel893",
    1: "birne726",
    2: "banane829",
    3: "tomate318",
    4: "kiwi367",
    5: "zwiebel982",
    6: "gurke716",
    7: "aubergine726",
    8: "zucchini571",
    9: "radieschen625",
  };

  /// Das Controller-Objekt
  DartbladeGameController _controller;

  /// Konstruktor des [DartBladeGameModel]
  /// Es wird eine Instanz des Controllers übergeben.
  DartBladeGameModel(this._controller);

  bool get levelWon => _levelWon;

  bool get leveLost => _levelLost;

  int get currentLevel => _currentLevel;

  String get levelSecret => _levelSecret;

  int get playerSpin => _player.spin;

  /// Setze sowohl Sieg- als auch Lost-Bedingung auf false. (Start des Levels)
  void initStartLevel(){
    _levelWon = false;
    _levelLost = false;
  }

  /// Setze Sieg-Bedingung auf true. (Level gewonnen!)
  void setLevelWon(){
    _levelWon = true;
    _levelLost = false;

  }

  /// Setze Lost-Bedingung auf true. (Level verloren!)
  void setLevelLost(){
    _levelLost = true;
    _levelWon = false;
  }

  /// Gibt die Map zurück, welche alle Tile-Typen enthält, welche im Level
  /// vorkommen können.
  List<List<TileTypes>> getMap() => _level._getLevelTypes();

  /// Holt sich die Level-Variablen aus einer JSON-Datei und ließt diese
  /// in das Model ein.
  Future<bool> loadLevelInModel(int levelNumber) async {
    _player = null;
    _level = null;
    if(!await LoadingLevel.getLevelDataFromJSON(levelNumber)) return false;
    _currentLevel = LoadingLevel._levelNumber;
    _levelSecret = getLevelSecretFromLevelNumber(_currentLevel);
    _level = new Level(LoadingLevel._levelStructur, LoadingLevel._levelNumber, LoadingLevel._size_x, LoadingLevel._size_y, this);
    return true;
  }

  /// Gibt das [levelSecret] des [currentLevel] zurück.
  String getLevelSecretFromLevelNumber(int currentLevel) {
    if(levelSecrets.containsKey(currentLevel)){
      return levelSecrets[currentLevel];
    }
  }

  /// Gibt die Nummer des Levels für ein entsprechendes [levelSecret] zurück.
  /// Dies wird gebraucht um bei der Eingabe eines [levelSecret] das dazugehörige
  /// Level laden zu können.
  int getLevelNumberFromLevelSecret(String levelSecret) {
    if(levelSecrets.containsValue(levelSecret)){
      var key = levelSecrets.keys.firstWhere((k) => levelSecrets[k] == "$levelSecret", orElse: () => null);
      return key;
    }else{
      return -1;
    }
  }
}