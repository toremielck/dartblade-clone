part of viewLib;

class DartbladeGameView{
  final blade = document.querySelector("#blade");
  final startButton = document.querySelector("#start");
  final enterSecretButton = document.querySelector("#entersecret");
  final initSpin = document.querySelector("#initSpin");
  final game = document.querySelector("#game");
  final level = document.querySelector("#level");
  final qr = document.querySelector("#qr");
  final changeView = document.querySelector("#changeView");
  final output = document.querySelector("#startmenu");
  final movingArea = document.querySelector("#movingArea");
  final debugOutput = document.querySelector("#debugOutput");


  // ViewPort
  int get width => window.innerWidth;
  int get height => window.innerHeight;
  int get size => min(this.width, this.height);

  int get movingAreaWidth => int.parse(movingArea.style.width);
  int get movingAreaHeight => int.parse(movingArea.style.height);
  int get movingAreaSize => min(movingAreaWidth, movingAreaHeight);


  double get movingAreaTop => center_y - (movingAreaHeight / 2);
  double get movingAreaBottom => center_y + (movingAreaHeight / 2);
  double get movingAreaLeft => center_x - (movingAreaWidth / 2);
  double get movingAreaRight => center_x + (movingAreaWidth / 2);


  double get center_x => this.width / 2;
  double get center_y => this.height / 2;


  void update (Blade player){
    player.update();

    final round = "${this.size}px";

    this.blade.style.top = "${player.top}px";
    this.blade.style.left = "${player.left}px";
    this.blade.style.width = "${player.width}px";
    this.blade.style.height = "${player.width}px";
    this.blade.style.borderRadius = round;
  }

  /*
  void shiftLevel(dx, dy) {
    this.level.style.marginTop = '${dy}px';
    this.level.style.marginLeft = '${dx}px';
  }
  */

  bool getLandscapeMode(int w, int h){
    return (w > h) ? true: false;
  }

  int count = 0;

  void shiftLevel(String direction) {
    switch (direction) {
      case 'up':
        count += 10;
        level.style.setProperty("margin-top", "${count}px");
        debugOutput.text =
        "shifting level ${direction} ${level.style.marginTop}";
        break;

      case 'down':
        debugOutput.text = "shifting level ${direction}";
        break;

      case 'left':
        debugOutput.text = "shifting level ${direction}";
        break;

      case 'right':
        debugOutput.text = "shifting level ${direction}";
        break;

      default:
        debugOutput.text = "no level shifting";
        break;

    /*
    if(direction == "up") {
      count++;
      level.style.setProperty("margin-top", "${count}px");
      debugOutput.text = "shifting level ${direction} ${level.style.marginTop}";
    } else if (direction == "down") {
      debugOutput.text = "shifting level ${direction} ${level.style.marginTop}";
    } else if (direction == "left") {
      debugOutput.text = "shifting level ${direction} ${level.style.marginTop}";
    } else if (direction == "right") {
      debugOutput.text = "shifting level ${direction} ${level.style.marginTop}";
    }
     */
    }
  }

}