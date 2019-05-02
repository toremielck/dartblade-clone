part of viewLib;

class DartbladeGameView{
  final blade = document.querySelector("#blade");
  final startButton = document.querySelector("#start");
  final enterSecretButton = document.querySelector("#entersecret");
  final initSpin = document.querySelector("#initSpin");
  final game = document.querySelector("#game");
  final bladeMovingArea = document.querySelector("#bladeMovingArea");
  final qr = document.querySelector("#qr");
  final output = document.querySelector("#startmenu");

  // ViewPort
  int get width => window.innerWidth;
  int get height => window.innerHeight;
  int get size => min(this.width, this.height);
  int get bladeMovingAreaHeight => int.parse(bladeMovingArea.style.height);
  int get bladeMovingAreaWidth => int.parse(bladeMovingArea.style.width);

  double get center_x => this.width / 2;
  double get center_y => this.height / 2;
  double get bladeMovingAreaCenter_x => bladeMovingAreaWidth / 2;
  double get bladeMovingAreaCenter_y => bladeMovingAreaHeight / 2;

  void update (Blade player){
    player.update();

    final round = "${this.size}px";

    this.blade.style.top = "${player.top}px";
    this.blade.style.left = "${player.left}px";
    this.blade.style.width = "${player.width}px";
    this.blade.style.height = "${player.width}px";
    this.blade.style.borderRadius=round;
  }
}