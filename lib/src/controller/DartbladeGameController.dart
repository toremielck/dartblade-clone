part of controllerLib;

class DartbladeGameController{

  Blade _player;
  DartbladeGameView _view;

  Timer spin;
  var mobile = false;


  /**
   * Constructor for the DartbladeGameController object
   * It creates a new view from DartBladeGameView and initilizes the model with the reference _player
   */
  DartbladeGameController(){
    _view = new DartbladeGameView();
    print(window.innerWidth); //debugg
    print(_view.width);
    _player = new Blade(_view.center_x, _view.center_y, _view.size / 16, _view);

    window.onDeviceOrientation.listen((ev) {
      // No device orientation
      if (ev.alpha == null && ev.beta == null && ev.gamma == null) {
        _view.qr.style.display = 'block'; // Show QR code
      }
      // Device orientation available
      else {
        _view.qr.style.display = 'none'; // Hide QR code
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
        _player.move(dx, dy);
      }
    });

  clickOnStart();

  }
  /**
  Starts the game by hiding the menu and starting the initilizeSpin() method.
  Then the postion of the _player object is set to the center of the viewport.
   */
  void clickOnStart(){
    _view.startButton.onClick.listen((e) {
      _view.output.style.display = 'none';
      _view.game.style.display = 'block';
      initialiseSpin();

      _player.position(_view.center_x, _view.center_y);
    });
  }

  // Methode für Spin -> bisher nur wie bekomm ich eineng Wert und zeige ihn an, starte danach das spiel ... muss noch alles bisschen aufgeteilt werden
  void initialiseSpin() {
    int count = 0;
    _view.initSpin.style.display = 'block';

    spin = Timer.periodic(new Duration(milliseconds: 500), (_) {
      if (count >= 10) count = 0;
      count++;
      _view.initSpin.text = "Spin: ${count}";
    });
    _view.initSpin.onClick.listen((ev) {
      spin.cancel();
      _view.initSpin.text = "Congrats, your spin is ${count}";
      new Timer.periodic(new Duration(milliseconds: 30), (update) {
        _view.update(_player);
      });
    });
  }




}