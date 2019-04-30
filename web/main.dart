import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'view/view.dart';
import 'model/Blade.dart';

void main() {


  Timer spin;
  final view = new View();
  var mobile = false;
  // change

  Blade player = new Blade(view.center_x, view.center_y, view.size / 16, view);

  window.onDeviceOrientation.listen((ev) {
    // No device orientation
    if (ev.alpha == null && ev.beta == null && ev.gamma == null) {
      view.qr.style.display = 'block'; // Show QR code
    }
    // Device orientation available
    else {
      view.qr.style.display = 'none'; // Hide QR code
      mobile = true;
      // Determine ball movement from orientation event
      //
      // beta: 30° no move, 10° full up, 50° full down
      // gamma: 0° no move, -20° full left, 20° full right
      // final dy = min(50, max(10, ev.beta)) - 30;
      //final dx = min(20, max(-20, ev.gamma));

      //landscape dx ist ok, aber dy bekomm ich nicht korrekt hin ?
      final dy = max(-80, min(-20, ev.gamma)) +50;
      final dx = min(20, max(-20,ev.beta));
      print(ev.alpha);
      player.move(dx, dy);
    }
  });

  // Methode für Spin -> bisher nur wie bekomm ich eineng Wert und zeige ihn an, starte danach das spiel ... muss noch alles bisschen aufgeteilt werden

  void initialiseSpin() {
    int count = 0;
    view.initSpin.style.display = 'block';

    spin = Timer.periodic(new Duration(milliseconds: 500), (_) {
      if (count >= 10) count = 0;
      count++;
      view.initSpin.text = "Spin: ${count}";
    });
    view.initSpin.onClick.listen((ev) {
      spin.cancel();
      view.initSpin.text = "Congrats, your spin is ${count}";
      new Timer.periodic(new Duration(milliseconds: 30), (update) {
        view.update(player);
      });
    });
  }

  view.startButton.onClick.listen((e) {
    view.output.style.display = 'none';
    view.game.style.display = 'block';
    initialiseSpin();

    player.position(view.center_x, view.center_y);
  });
}
