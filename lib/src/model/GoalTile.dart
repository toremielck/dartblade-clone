part of modelLib;

class GoalTile extends SpecialTile{
  GoalTile(int x, int y, DartBladeGameModel model) : super(x, y, model);



  @override void _actionOnCollision(){
    print("level geschafft");

  }


}