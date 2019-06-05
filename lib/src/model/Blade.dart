part of modelLib;

class Blade extends Entity {
  double position_x;
  double position_y;
  double direction_x = 0.0;
  double direction_y = 0.0;

  double radius;
  int spin;
  bool onfield;

  DartBladeGameView view;
  Level _level;

  Blade(double x, double y,  this.radius, this.view)
      : super(x.floor(), y.floor()) {
  }

  int get top => (this.position_y - this.radius).floor();

  int get bottom => (this.position_y + this.radius).floor();

  int get left => (this.position_x - this.radius).floor();

  int get right => (this.position_x + this.radius).floor();

  int get width => (2 * this.radius).floor();

  int get height => (2 * this.radius).floor();

  // Alle Tiles in einer Liste speichern für collsion detection
  List<Element> saveAllTilesInList() {
    var tiles = new List<Element>();

    view.level.children.forEach((tile) {
      tiles.add(tile);
    });

    return tiles;
  }

  // Calculate the center of the blade
  Point bladeCenterPoint() {
    Point offsetBlade = view.blade.documentOffset;
    Point bladeCenterPoint = new Point(offsetBlade.x + this.radius.floor(), offsetBlade.y + this.radius.floor());
    return bladeCenterPoint;
  }

  // Calculate the center of a field
  Point fieldCenterPoint(Element field) {
    Point offsetField = field.documentOffset;
    Point fieldCenterPoint = new Point(offsetField.x + 25, offsetField.y + 25);
    return fieldCenterPoint;
  }

  // collision detection
  void collisionDetection() {

    var tiles = saveAllTilesInList();

     tiles.forEach((tile) {

      if (bladeCenterPoint().x >= fieldCenterPoint(tile).x - 25 &&
          bladeCenterPoint().x <= fieldCenterPoint(tile).x + 25 &&
          bladeCenterPoint().y >= fieldCenterPoint(tile).y - 25 &&
          bladeCenterPoint().y <= fieldCenterPoint(tile).y + 25) {

        // DEBUG
        view.moveLevelDebug(null, tile.getAttribute("tileType"));
        if(tile.getAttribute("tileType") == "goal-tile"){
          view.displayLevelFinshed.style.display = 'block';
          view.blade.style.display = 'none';
          view.level.style.display = 'none';
        }
        /* boxB.style.animationPlayState = boxB.style.animationPlayState == 'paused' ? 'running' : 'paused' */
        if (tile.getAttribute("tileType") == "spin-tile") {
          view.level.style.animationPlayState = view.level.style.animationPlayState == 'paused' ? 'running' : 'paused';
        }

      }

    });

  }

  /**
   * Sets the moving vector [dx] and [dy] of the circle.
   * The next update will shift the center position of
   * the circle according to this ([dx], [dy] vector).
   */
  void move(double dx, double dy) {

    this.direction_x = dx;
    this.direction_y = -dy;
  }

  /**
   * Sets the absolute position of the center of the
   * circle to [cx] and [cy] position.
   */
  void position(double px, double py) {
    this.position_x = px;
    this.position_y = py;
  }

  /**
   * Updates the position of the circle.
   * It is assured that the circle will remain in the viewport of the [view].
   */

  void update() {

    view.moveLevelDebug();

    collisionDetection();

    this.position_x += this.direction_x;
    this.position_y += this.direction_y;

    // Stellt sicher, dass der Blade innerhalb des viewports bleibt
    if (this.top < 1) {
      this.position_y = this.radius + 1;
      view.moveLevel("down", 5);
    }
      if (this.bottom > this.view.height - 1) {
        this.position_y = this.view.height - this.radius - 1;
        view.moveLevel("up", 5);
      }

      if (this.left < 1) {
        this.position_x = this.radius + 1;
        view.moveLevel("left", 5);
      }
      if (this.right > this.view.width - 1) {
        this.position_x = this.view.width - this.radius - 1;
        view.moveLevel("right", 5);
      }

  }

}