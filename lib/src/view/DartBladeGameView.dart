part of viewLib;

class DartBladeGameView {

  /// Laden aller benötigeten HTML-Elemente in Konstanten
  final blade = document.querySelector("#blade");
  final startButton = document.querySelector("#start");
  final enterSecretButton = document.querySelector("#entersecret");
  final instructions = document.querySelector("#instructions");
  final instructionsText = document.querySelector("#instructionsText");
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
  final enterSecretField = document.querySelector("#secretInput");
  final secretEntered = document.querySelector("#secretEntered");
  final wrongSecret = document.querySelector("#wrongSecret");
  final displayGameWon = document.querySelector("#displayGameWon");

  final getSpin = document.querySelector("#getSpin");
  final startLevel = document.querySelector("#startLevel");


  /// ViewPort-Variablen
  int get width => window.innerWidth;
  int get height => window.innerHeight;
  int get size => min(this.width, this.height);

  double get center_x => this.width / 2;
  double get center_y => this.height / 2;

  /// Positions-Variablen des Levels
  int levelPositionTop = 0;
  int levelPositionRight = 0;

  /// Updatet die Positionswerte des Players
  void update (Blade player){
    player.update();

    final round = "${this.size}px";

    this.blade.style.top = "${player.top}px";
    this.blade.style.left = "${player.left}px";
    this.blade.style.width = "${player.width}px";
    this.blade.style.height = "${player.width}px";
    this.blade.style.borderRadius = round;
  }

  /// Abfragen ob der Landscape-Mode aktiv ist.
  bool getLandscapeMode(int w, int h){
    return (w > h) ? true : false;
  }

  /// Bewegen des Levels in eine [direction] und mit einem [movingSpeed]
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

  /// Füllen des HTML-Level-Elements mit den verschiedenen Tile-Typen als Divs
  ///
  /// Es wird jedem Div ein Typ und ein x-, sowie y-Wert mitgegeben.
  void fillLevelWithEntity(List<List<TileTypes>> l ){

    int _row = 0;
    int _col = 0;

    /// Gehe die Liste mit den verschiedenen Typen an Tiles, welche übergeben wird
    /// durch und füge je nachdem, welches es ist eines in das HTML-Level-Element ein.
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

  /// Zeige an, dass das Level mit der entsprechenden [levelNumber] gewonnen wurde.
  /// Zeige das [levelSecret] an.
  void showLevelFinished(int levelNumber, String levelSecret){
    displayLevelFinished.innerHtml =
        "Level $levelNumber: finished <br>"
        "Your Level Code: $levelSecret <br>";

    displayLevelFinished.style.display = "block";
  }

  /// Verstecke das Overlay, welches beim Sieg nach einem Level angezeigt wird.
  void hideLevelFinished(){
    displayLevelFinished.style.display = "none";
  }

  /// Zeige an, dass das Level mit der antsprechenden [levelNumber] verloren wurde.
  void showLevelFailed(int levelNumber){
    displayLevelFailed.innerHtml =
        "Level $levelNumber: failed <br>"
        "be careful <br>"
        "tap to restart <br>";

    displayLevelFailed.style.display = "block";
  }


  /// Verstecke das Overlay, welches beim Verlieren nach einem Level angezeigt wird.
  void hideLevelFailed(){
    displayLevelFailed.style.display = "none";
  }

  void showEnterSecretField(){
    enterSecretField.style.display ="block";
  }
  void hideEnterSecretField(){
    enterSecretField.style.display = "none";
  }

  void showInstructiontext(){
    instructionsText.innerHtml =
    "Instructions <hr>"
    "-reach the goal tile  <img src=\"img/goal.png\"> before your blade has no spin<br><br>"
    "-if you fall down, restart the level<br><br>"
    "-after sucess a level you get a secret<br><br>"
    "-type the secret to start from this level <br><br>"
    "-good luck and have fun<br><br>"
    "-tip to go back to menu"
    ;
    instructionsText.style.display ="block";
  }
  void hideInstructionText(){
    instructionsText.style.display = "none";
  }

  void showWrongSecretMessage(){
    wrongSecret.innerHtml = "Wrong Secret: try again";
    wrongSecret.style.display = "block";
  }
  void hideWrongSecretMessage(){
    wrongSecret.style.display = "none";
  }
  void showGameWon(){
    displayGameWon.innerHtml ="You beat the Game | reload page to play again";
    displayGameWon.style.display = "block";

  }

  void hideGameWon(){
    displayGameWon.style.display = "none";

  }


}