part of modelLib;


class Blade extends Entity {
  double position_x;
  double position_y;
  double direction_x = 0.0;
  double direction_y = 0.0;

  double radius;
  double spin;
  bool onfield;

  DartbladeGameView view;

  Blade(double x, double y, bool collision,  this.radius, this.view)
      : super(x, y, collision) {
  }

  int get top => (this.position_y - this.radius).floor();

  int get bottom => (this.position_y + this.radius).floor();

  int get left => (this.position_x - this.radius).floor();

  int get right => (this.position_x + this.radius).floor();

  int get width => (2 * this.radius).floor();

  int get height => (2 * this.radius).floor();

  //Point get center => Point(this.width - (this.width / 2), this.center_y);

  Point bladeCenterPoint(){
    Point t = view.blade.documentOffset;
    Point tmp = new Point(t.x + this.radius.floor(), t.y + this.radius.floor());
    return tmp;
  }
  Point feldCenterPoint(){
    Point t = view.feld.documentOffset;
    Point tmp = new Point(t.x + 25, t.y + 25);
    return tmp;
  }


  double get center_y => this.height / 2;

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

    // Collision detection für nur ein Feld (proof of concept)
    if (bladeCenterPoint().x >= feldCenterPoint().x - 25 &&
        bladeCenterPoint().x <= feldCenterPoint().x + 25 &&
        bladeCenterPoint().y >= feldCenterPoint().y - 25 &&
        bladeCenterPoint().y <= feldCenterPoint().y + 25) {

        print("Blade mit Feld kollidiert!");
    }
    
    // Initialer Aufruf der Debug-Funktion für Position des Levels
    view.moveLevelDebug();
    
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