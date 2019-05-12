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

  /**
   * Sets the moving vector [dx] and [dy] of the circle.
   * The next update will shift the center position of
   * the circle according to this ([dx], [dy] vector).
   */
  void move(double dx, double dy) {
  //  view.shiftLevel(dx, dy);
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
  /*
  void update() {
    this.position_x += this.direction_x;
    this.position_y += this.direction_y;

    if (this.top < this.view.movingAreaTop) this.position_y = this.view.movingAreaTop;
    if (this.bottom > this.view.movingAreaBottom)
      this.position_y = this.view.movingAreaBottom;

    if (this.left < this.view.movingAreaLeft) this.position_x = this.view.movingAreaLeft;
    if (this.right > this.view.movingAreaRight)
      this.position_x = this.view.movingAreaRight;
  }
  */

  void update() {
    this.position_x += this.direction_x;
    this.position_y += this.direction_y;

    if (this.top < 50) this.position_y = this.radius +50;
    if (this.bottom > this.view.height - 50 - 1)
      this.position_y = this.view.height - 1 - this.radius -50;

    if (this.left < 150) this.position_x = this.radius +150;
    if (this.right > this.view.width-150 - 1)
      this.position_x = this.view.width - 1 - this.radius -150;
  }

}