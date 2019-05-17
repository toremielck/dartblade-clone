part of viewLib;

class DartbladeGameView{
  final blade = document.querySelector("#blade");
  final startButton = document.querySelector("#start");
  final enterSecretButton = document.querySelector("#entersecret");
  final spinDisplay = document.querySelector("#spinDisplay");
  final game = document.querySelector("#game");
  final level = document.querySelector("#level");
  final qr = document.querySelector("#qr");
  final changeView = document.querySelector("#changeView");
  final output = document.querySelector("#startmenu");
  final movingArea = document.querySelector("#movingArea");
  final debugOutput = document.querySelector("#debugOutput");


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
    return (w > h) ? true: false;
  }

  void moveLevel(direction, movingFactor) {

    switch (direction) {
      case 'up':
        levelPositionTop -= movingFactor;
        level.style.setProperty("top", "${levelPositionTop}px");

        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);

        break;

      case 'down':
        levelPositionTop += movingFactor;
        level.style.setProperty("top", "${levelPositionTop}px");

        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);

        break;

      case 'left':
        levelPositionRight -= movingFactor;
        level.style.setProperty("right", "${levelPositionRight}px");

        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);

        break;

      case 'right':
        levelPositionRight += movingFactor;
        level.style.setProperty("right", "${levelPositionRight}px");

        // Debug output für die Richtung der Bewegung des Levels
        moveLevelDebug(direction);

        break;

      default:
        debugOutput.text = "no level shifting";
        break;

    }
  }

  void moveLevelDebug([direction]) {

    // Falls sich das Level nicht bewegt setze direction auf "none"
    if (direction == null) direction = "none";

    debugOutput.innerHtml =
        "moving level: ${direction} <br>"
        "Position level top: ${level.style.top} <br>"
        "Position level right: ${level.style.right}";
  }

}