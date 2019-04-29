import 'dart:html';
import 'dart:math';

import '../model/Blade.dart';

class View{

  var blade = querySelector("#blade");
  var startButton = querySelector("#start");
  final enterSecretButton = querySelector("#entersecret");
  final initSpin = querySelector("#initSpin");
  var game = document.querySelector("#game");
  final qr = querySelector("#qr");
  var output = document.querySelector("#startmenu");
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
    this.blade.style.borderRadius=round;
  }

  void generateField() {

  }

  void showSpin() {

  }

  void showTime() {

  }

  void warnLowSpin() {

  }

  void gameOverScreen() {

  }
}