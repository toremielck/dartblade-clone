import 'dart:html';

void main() {
  var output = document.querySelector("#output");
  var startButton = document.querySelector("#start");
  var game = document.querySelector("#game");
  var qr = document.querySelector("noSmartphone");

  var mobile = false;
  startButton.onClick.listen((e){
    output.style.display = 'none';
    game.style.display = 'block';
  });

  window.onDeviceOrientation.listen((ev) {
    if(ev.alpha == null && ev.beta == null && ev.gamma == null){
      qr.style.display = 'block';
    }
    else{
      qr.style.display = 'none';
      mobile = true;
    }
  });



}
