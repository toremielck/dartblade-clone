part of viewLib;

class DartBladeGameView {
  final blade = document.querySelector("#blade");
  final startButton = document.querySelector("#start");
  final enterSecretButton = document.querySelector("#entersecret");
  final spinDisplay = document.querySelector("#spinDisplay");
  final game = document.querySelector("#game");
  final level = document.querySelector("#level");
  final displayUseSmartphone = document.querySelector("#displayUseSmartphone");
  final changeView = document.querySelector("#changeView");
  final output = document.querySelector("#startMenu");
  final movingArea = document.querySelector("#movingArea");
  final debugOutput = document.querySelector("#debugOutput");
  final displayLevelFinished = document.querySelector("#displayLevelFinished");
  final displayLevelFailed = document.querySelector("#displayLevelFailed");
  final getSpin = document.querySelector("#getSpin");
  final startLevel = document.querySelector("#startLevel");


  // ViewPort-Variablen
  int get width => window.innerWidth;
  int get height => window.innerHeight;
  int get size => min(this.width, this.height);

  double get center_x => this.width / 2;
  double get center_y => this.height / 2;

  // Positions-Variablen des Levels
  int levelPositionTop = 0;
  int levelPositionRight = 0;


  void update (Blade player){
    player.update();

    final round = "${this.size}px";

    this.blade.style.top = "${player.top}px";
    this.blade.style.left = "${player.left}px";
    this.blade.style.width = "${player.width}px";
    this.blade.style.height = "${player.width}px";
    this.blade.style.borderRadius = round;
  }

  bool getLandscapeMode(int w, int h){
    return (w > h) ? true : false;
  }

  void moveLevel(direction, movingSpeed) {

    switch (direction) {
      case 'up':
        levelPositionTop -= movingSpeed;
        level.style.setProperty("top", "${levelPositionTop}px");
        // Debug output für die Richtung der Bewegung des Levels
        (direction);
        break;
      case 'down':
        levelPositionTop += movingSpeed;
        level.style.setProperty("top", "${levelPositionTop}px");
        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);
        break;
      case 'left':
        levelPositionRight -= movingSpeed;
        level.style.setProperty("right", "${levelPositionRight}px");
        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);
        break;
      case 'right':
        levelPositionRight += movingSpeed;
        level.style.setProperty("right", "${levelPositionRight}px");
        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);
        break;
      default:
        break;

    }
  }

  void fillLevelWithEntity(List<List<TileTypes>> l ){
   // var oneEntity = level.children[0].children[0];


    int _row = 0;
    int _col = 0;
    for(List<TileTypes> row in l){
      var tileDiv = new DivElement();
      tileDiv.className = "tr";
      level.children.add(tileDiv);
      for(TileTypes s in row){
        switch (s){
          case TileTypes.GROUNDTILE:
            var tileDiv = new DivElement();
            tileDiv.className = "td ground-tile";
            tileDiv.setAttribute("tileType", "ground-tile");
            tileDiv.setAttribute("x", "$_col");
            tileDiv.setAttribute("y", "$_row");
            level.children.add(tileDiv);
            break;
          case TileTypes.GAMEOVERTILE:
            var tileDiv = new DivElement();
            tileDiv.className = "td gameover-tile";
            tileDiv.setAttribute("tileType", "gameover-tile");
            tileDiv.setAttribute("x", "$_col");
            tileDiv.setAttribute("y", "$_row");
            level.children.add(tileDiv);
            break;
          case TileTypes.SPINTILE:
            var tileDiv = new DivElement();
            tileDiv.className = "td spin-tile";
            tileDiv.setAttribute("tileType", "spin-tile");
            tileDiv.setAttribute("x", "$_col");
            tileDiv.setAttribute("y", "$_row");

            level.children.add(tileDiv);
            break;
          case TileTypes.GOALTILE:
            var tileDiv = new DivElement();
            tileDiv.className = "td goal-tile";
            tileDiv.setAttribute("tileType", "goal-tile");
            tileDiv.setAttribute("x", "$_col");
            tileDiv.setAttribute("y", "$_row");
            level.children.add(tileDiv);
            break;
          default:
            break;
        }
        _col++;
      }

      _col = 0;
      _row++;
    }
  }

  void moveLevelDebug( [direction, collisionField]) {

    // Falls sich das Level nicht bewegt setze direction auf "none"
    if (direction == null) direction = "none";

    debugOutput.innerHtml =
        "moving level: ${direction} <br>"
        "Position level top: ${level.style.top} <br>"
        "Position level right: ${level.style.right} <br>"
        "collision with field: ${collisionField}";
  }

  void showLevelFinished(int levelNumber, String levelSecret){
    displayLevelFinished.innerHtml =
        "Level $levelNumber: finished <br>"
        "Your Level Code: $levelSecret <br>";

    displayLevelFinished.style.display = "block";
  }
  void hideLevelFinished(){
    displayLevelFinished.style.display = "none";
  }

  void showLevelFailed(int levelNumber){
    displayLevelFailed.innerHtml =
        "Level $levelNumber: failed <br>"
        "Be faster next time :) <br>"
        "tap to restart <br>";
    displayLevelFailed.style.display = "block";
  }
  void hideLevelFailed(){
    displayLevelFailed.style.display = "none";
  }



}