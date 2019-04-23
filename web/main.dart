import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'view/view.dart';
import 'model/blade.dart';
void main() {

  var startButton = document.querySelector("#start");
  var game = document.querySelector("#game");
  var qr = document.querySelector("noSmartphone");
  var output = document.querySelector("#output");

  final view = new View();
  var mobile = false;

  Blade player = new Blade(view.center_x, view.center_y, view.size / 8, view);
  print(player.width);
  view.update(player);

  window.onDeviceOrientation.listen((ev) {
    if(ev.alpha == null && ev.beta == null && ev.gamma == null){
      qr.style.display = 'block';
    }
    else{
      qr.style.display = 'none';
      mobile = true;
      final directiony = min(50, max(10, ev.beta)) - 30;
      final directionx = min(20, max(-20, ev.gamma));
      player.move(directionx, directiony);
    }
  });

  startButton.onClick.listen((e){
    player.position(view.center_x, view.center_y);
    output.style.display = 'none';
    game.style.display = 'block';


    new Timer.periodic(new Duration(milliseconds: 30), (update) {

      view.update(player);


    });



  });
}