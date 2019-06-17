part of modelLib;

class Blade extends Entity {
  double position_x;
  double position_y;
  double direction_x = 0.0;
  double direction_y = 0.0;

  double radius;
  int spin;

  DartBladeGameView view;
  DartBladeGameModel _model;
  Level _level;

  /// Konstruktor der [Blade] Klasse
  /// Es werden die View und das Model mit übergeben.
  Blade(double x, double y,  this.radius, this.view, this._model)
      : super(x.floor(), y.floor()) {
  }

  int get top => (this.position_y - this.radius).floor();

  int get bottom => (this.position_y + this.radius).floor();

  int get left => (this.position_x - this.radius).floor();

  int get right => (this.position_x + this.radius).floor();

  int get width => (2 * this.radius).floor();

  int get height => (2 * this.radius).floor();

  /// Alle Tiles in einer Liste speichern für die collsion detection
  List<Element> saveAllTilesInList() {
    var tiles = new List<Element>();

    view.level.children.forEach((tile) {
      tiles.add(tile);
    });

    return tiles;
  }

  /// Gibt immer die aktuelle Position des Blades zurück.
  Point bladeCenterPoint() {
    Point offsetBlade = view.blade.documentOffset;
    Point bladeCenterPoint = new Point(offsetBlade.x + this.radius.floor(), offsetBlade.y + this.radius.floor());
    return bladeCenterPoint;
  }

  /// Berechnet (auch während sich das Level selbst bewegt) den Mittelpunkt eines
  /// einzigen Tiles, welches als Parameter übergeben wird.
  Point fieldCenterPoint(Element field) {
    Point offsetField = field.documentOffset;
    Point fieldCenterPoint = new Point(offsetField.x + 25, offsetField.y + 25);
    return fieldCenterPoint;
  }

  /// Collision detection
  /// Die collision detection geht durchgehend die Liste aller Tiles durch und
  /// überprüft, ob der Mittelpunkt des Players eine der Seiten eines Tiles berührt
  /// hat.
  /// Je nachdem welcher Tile-Typ es ist wird eine oder keine Aktion ausgeführt.
  void collisionDetection() {

    /// Einlesen der Liste aller Tiles
    var tiles = saveAllTilesInList();

    /// Eigentliche collision detection
     tiles.forEach((tile) {

      if (bladeCenterPoint().x >= fieldCenterPoint(tile).x - 25 &&
          bladeCenterPoint().x <= fieldCenterPoint(tile).x + 25 &&
          bladeCenterPoint().y >= fieldCenterPoint(tile).y - 25 &&
          bladeCenterPoint().y <= fieldCenterPoint(tile).y + 25) {

        // DEBUG
        view.moveLevelDebug(null, tile.getAttribute("tileType"));


        if(tile.getAttribute("tileType") == "ground-tile"){
          _model.initStartLevel();
        }

        /// Sollte der Spieler auf dem Goal-Tile laden, setzte im Model, dass
        /// das Level gewonnen wurde.
        if(tile.getAttribute("tileType") == "goal-tile"){
        _model.setLevelWon();
        }

        /// Sollte der Spieler auf dem Gameover-Tile laden, setzte im Model, dass
        /// das Level verloren wurde.
        if(tile.getAttribute("tileType") == "gameover-tile"){
          _model.gameoverTrigger++;
          _model.setLevelLost();
        }

        /// Sollte der Spieler auf dem Spin-Tile laden, wird ausgeführt, dass
        /// das geasmte Level wackelt. Dies erhöht die Schwierigkeit des Spiels!
        if (tile.getAttribute("tileType") == "spin-tile") {
          view.level.style.animationPlayState = view.level.style.animationPlayState == 'paused' ? 'running' : 'paused';
        }

      }

    });

  }

  /// Setzt die neue Richtung des Players
  void move(double dx, double dy) {

    this.direction_x = dx;
    this.direction_y = -dy;
  }

  /// Setzt die absolute Position des Players
  void position(double px, double py) {
    this.position_x = px;
    this.position_y = py;
  }

  void setPosition(double newX, double newY){
    this.position_x = newX;
    this.position_y = newY;
  }

  /// Updatet die Position des Players entsprechend der Werte des Gyro-Sensors
  /// und führt die collision detection aus.
  void update() {

    collisionDetection();

    this.position_x += this.direction_x;
    this.position_y += this.direction_y;

    /// Stellt sicher, dass der Blade innerhalb des Viewports bleibt und sich nur das
    /// Level darunter in die entgegengesetzte Richtung bewegt.

    /// BEGRENZUNG OBEN
    if (this.top < 1) {
      this.position_y = this.radius + 1;
      view.moveLevel("down", 5);
    }

    /// BEGRENZUNG UNTEN
    if (this.bottom > this.view.height - 1) {
      this.position_y = this.view.height - this.radius - 1;
      view.moveLevel("up", 5);
    }

    /// BEGRENZUNG LINKS
    if (this.left < 1) {
      this.position_x = this.radius + 1;
      view.moveLevel("left", 5);
    }

    /// BEGRENZUNG RECHTS
    if (this.right > this.view.width - 1) {
      this.position_x = this.view.width - this.radius - 1;
      view.moveLevel("right", 5);
    }

  }

}