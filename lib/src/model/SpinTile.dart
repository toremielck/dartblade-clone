part of modelLib;

class SpinTile extends SpecialTile{
  SpinTile(int x, int y, DartBladeGameModel model) : super(x, y, model);

  @override
  void actionOnCollision(){
    print("get spin");
  }
}