part of modelLib;

class GameOverTile extends SpecialTile{
  GameOverTile(int x, int y, DartBladeGameModel model) : super(x, y, model);

  @override
  void actionOnCollision(){
    print("level geschafft");
  }

}