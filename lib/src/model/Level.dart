part of modelLib;

class Level{

  // Position des Levels
  int _position_x;
  int _position_y;

  int get position_x => _position_x;
  int get position_y => _position_y;

  set position_x(int value) {
    _position_x = value;
  }

  set position_y(int value) {
    _position_y = value;
  }

}