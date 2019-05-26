part of modelLib;

abstract class Entity{
  double _x;
  double _y;
  bool _isCollisionPossible;

  Entity(this._x, this._y, this._isCollisionPossible);
}