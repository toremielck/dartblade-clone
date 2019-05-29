part of modelLib;

class SpecialTile extends Tile{

  DartBladeGameModel _model;

  SpecialTile (int x, int y, this._model) : super (x, y) {
  }

  void actionOnColission() {
    print("hello");
  }

}