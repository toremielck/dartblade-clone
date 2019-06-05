part of modelLib;

class GroundTile extends SpecialTile{
  GroundTile(int x, int y, DartBladeGameModel model) : super(x, y, model);



  @override void actionOnCollision(){
    print("ground tile");
    super._actionOnColission();
  }

}