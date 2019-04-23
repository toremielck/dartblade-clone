import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'view/view.dart';
import 'model/blade.dart';
void main() {

  var startButton = document.querySelector("#start");
  var game = document.querySelector("#game");
  final qr = querySelector("#qr");
  var output = document.querySelector("#startmenu");

  final view = new View();
  var mobile = false;

  Blade player = new Blade(view.center_x, view.center_y, view.size / 16, view);
  print(player.width);
  view.update(player);

  window.onDeviceOrientation.listen((ev) {

    // No device orientation
    if (ev.alpha == null && ev.beta == null && ev.gamma == null) {
      qr.style.display = 'block'; // Show QR code
    }
    // Device orientation available
    else {
      qr.style.display = 'none'; // Hide QR code
      mobile = true;
      // Determine ball movement from orientation event
      //
      // beta: 30° no move, 10° full up, 50° full down
      // gamma: 0° no move, -20° full left, 20° full right
      //
      final dy = min(50, max(10, ev.beta)) - 30;
      final dx = min(20, max(-20, ev.gamma));
      player.move(dx, dy);
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