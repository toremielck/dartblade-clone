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


  bool getLandscapeMode(int w, int h){
    return (w > h) ? true: false;
  }

  int count = 0;

  void shiftLevel(String direction) {
    switch (direction) {
      case 'up':
        count -= 5;
        level.style.setProperty("top", "${count}px");
        debugOutput.text = "shifting level ${direction}";
        break;

      case 'down':
        count += 5;
        level.style.setProperty("top", "${count}px");
        debugOutput.text = "shifting level ${direction}";
        break;

      case 'left':
        count += 5;
        level.style.setProperty("right", "${count}px");
        debugOutput.text = "shifting level ${direction}";
        break;

      case 'right':
        count -= 5;
        level.style.setProperty("right", "${count}px");
        debugOutput.text = "shifting level ${direction}";
        break;

      default:
        debugOutput.text = "no level shifting";
        break;

    }
  }

}