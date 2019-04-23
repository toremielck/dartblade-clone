import '../view/view.dart';

class Blade {
  double positionx;
  double positiony;
  double directionx;
  double directiony;

  double radius;
  double spin;
  bool onfield;

  View view;

  Blade(this.directionx, this.directiony, this.radius, this.view){}

  int get top => (this.directiony - this.radius).floor();

  int get bottom => (this.directiony + this.radius).floor();

  int get left => (this.directionx - this.radius).floor();

  int get right => (this.directionx + this.radius).floor();

  int get width => (2 * this.radius).floor();

  int get height => (2 * this.radius).floor();

  /**
   * Sets the moving vector [dx] and [dy] of the circle.
   * The next update will shift the center position of
   * the circle according to this ([dx], [dy] vector).
   */
  void move(double directionx, double directiony){
    this.directionx = directionx;
    this.directiony = directiony;
  }
  /**
   * Sets the absolute position of the center of the
   * circle to [cx] and [cy] position.
   */
  void position(double px, double py){
    this.positionx = px;
    this.positiony = py;
  }
/**
 * Updates the position of the circle.
 * It is assured that the circle will remain in the viewport of the [view].
 */
  void update(){
    this.positionx += this.directionx;
    this.positiony += this.directiony;

    if (this.top < 0) this.positiony = this.radius;
    if (this.bottom > this.view.height - 1) this.positiony = this.view.height - 1 - this.radius;

    if (this.left < 0) this.positionx = this.radius;
    if (this.right > this.view.width - 1) this.positionx = this.view.width - 1 - this.radius;
  }
}