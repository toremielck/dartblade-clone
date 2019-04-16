import 'dart:html';

void main() {
  var output = document.querySelector("#output");
  var startButton = document.querySelector("#start");
  var game = document.querySelector("#game");
  var qr = document.querySelector("noSmartphone");
  var mobile = false;

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

    }
  });
  startButton.onClick.listen((e){
    output.style.display = 'none';
    game.style.display = 'block';
  });


  




}
