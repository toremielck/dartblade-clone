import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'view/view.dart';
import 'model/Blade.dart';
void main() {

  var startButton = document.querySelector("#start");
  final entersecretButton = querySelector("#entersecret");
  final initSpin = querySelector("#initSpin");
  var game = document.querySelector("#game");
  final qr = querySelector("#qr");
  var output = document.querySelector("#startmenu");
  Timer spin;
  final view = new View();
  var mobile = false;

  Blade player = new Blade(view.center_x, view.center_y, view.size / 16, view);


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

  // Methode für Spin -> bisher nur wie bekomm ich einen Wert und zeige ihn an, starte danach das spiel ... muss noch alles bisschen aufgeteilt werden

  void initialiseSpin(){
    int count = 0;
    initSpin.style.display = 'block';

    spin = Timer.periodic(new Duration(milliseconds: 500), (_) {
      if(count >= 10) count=0;
      count++;
      initSpin.text = "Spin: ${count}";
    });
    initSpin.onClick.listen((ev){
      spin.cancel();
      initSpin.text = "Congrats, your spin is ${count}";
      new Timer.periodic(new Duration(milliseconds: 30), (update) {

        view.update(player);


      });
    });

  }

  startButton.onClick.listen((e){
    output.style.display = 'none';
    game.style.display = 'block';
    initialiseSpin();



    player.position(view.center_x, view.center_y);




  });
}