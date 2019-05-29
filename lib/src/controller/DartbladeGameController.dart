part of controllerLib;

class DartbladeGameController{

  // Verknüpfung zum Model
  DartBladeGameModel _model;

  // Verknüpfung zum View
  DartBladeGameView _view;

  Blade _player;

  Timer spin;

  int _currentLevel = 0;
  /**
   * Constructor for the DartbladeGameController object
   * It creates a new view from DartBladeGameView and initilizes the model with the reference _player
   */
  DartbladeGameController(){
    _view = new DartBladeGameView();
    _model = new DartBladeGameModel(this);
    _player = new Blade(_view.center_x, _view.center_y, 25, _view);

    window.onDeviceOrientation.listen((ev) {
      // No device orientation
      if (ev.alpha == null && ev.beta == null && ev.gamma == null) {
        _view.displayUseSmartphone.style.display = 'block'; // Show QR code
      }
      // Device orientation available
      else {
        _view.displayUseSmartphone.style.display = 'none'; // Hide QR code
        if (_view.getLandscapeMode(_view.width, _view.height) == false) {
          _view.changeView.style.display = 'block';
        } else {
          _view.changeView.style.display = 'none';

          // Determine ball movement from orientation event
          //
          // beta: 30° no move, 10° full up, 50° full down
          // gamma: 0° no move, -20° full left, 20° full right
          // final dy = min(50, max(10, ev.beta)) - 30;
          //final dx = min(20, max(-20, ev.gamma));

          //zu beachten : dy wird in der Klasse Blade in der Funktion umgekehrt !!
          final dx = min(20, max(-20, ev.beta));
          final dy = min(-20, max(-80, ev.gamma)) + 50;

          /*
          //DEBUG-Funktion für die Gyro-Werte
          void debugGyroValues() {
            _view.game.innerHtml = "alpha: " + ev.alpha.toInt().toString() +
                " <br>beta: " + ev.beta.toInt().toString() +
              " <br>gamma: " + ev.gamma.toInt().toString() +
              " <br> dx: " + dx.toInt().toString() +
              " <br> dy: " + dy.toInt().toString();
          }
          */
          _player.move(dx, dy);
        }
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

      Level level = new Level(_view);
      level.getLevelDataFromJSON(0);
      // Aufruf der Methode um den Spin des Kreisels zu initialisieren
      initialiseSpin();

      _player.position(_view.center_x, _view.center_y);
    });
  }



  // Den Spin des Kreisels initialisieren und das Spiel starten
  void initialiseSpin() {
    int spinCount = 0;
    _view.spinDisplay.style.display = 'block';
    spin = Timer.periodic(new Duration(milliseconds: 250), (_) {
      if (spinCount >= 10) spinCount = 0;
      spinCount++;
      _view.spinDisplay.text = "Spin: ${spinCount}";
    });

    // Bei einem Klick auf das Spin-Feld wird der Spin-Timer beendet
    // und das Spiel wird gestartet
    _view.spinDisplay.onClick.listen((ev) {
      spin.cancel();

      new Timer.periodic(new Duration(milliseconds: 50), (update) {
        _view.update(_player);
      });
    });
  }

  /*
  // Starte Spiel entweder mit Level 0 oder einem dem levelSecret entsprechendem Level!
  void startGame([String levelSecret, int levelNumber]) {

   // Starte bei Level 0
    // TODO: Umstrukturieren
    if (levelSecret == null && levelNumber == null) {
      Level level = new Level(_currentLevel);
    } else if (levelNumber > 0) {
      Level level = new Level(_currentLevel);
    } else if (levelSecret != null) {
      _currentLevel = getLevelNumberFromLevelSecret(levelSecret);
      if (_currentLevel == -1) {
       //Steuerung für die View, wenn levelsecret gefunden, aber falsch
      } else {
        //erstelle Level vom levelSecret
        Level level = new Level(_currentLevel);
      }
    }
  }
  */

  int getLevelNumberFromLevelSecret(String levelSecret) {
    Map _levelSecretMap = new Map();
    _levelSecretMap[0] = 'abc';
    _levelSecretMap[1] = '123';
    _levelSecretMap[2] = 'qwe';

    _levelSecretMap.forEach((levelNumber, s) {
      if(levelSecret == s.toString()) {
        return int.parse(levelNumber);
      }
    });
    return -1;
  }

}
