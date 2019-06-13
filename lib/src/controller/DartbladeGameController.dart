part of controllerLib;

class DartbladeGameController{

  Duration initSpinDurationSpeed = Duration(milliseconds: 50);
  Duration spinTimerSpeed = Duration(milliseconds: 1000);
  Duration playerTimerSpeed = Duration(milliseconds: 50);

  // Verknüpfung zum Model und View
  DartBladeGameModel _model;
  DartBladeGameView _view;

  Blade _player;
  int spinCount = 0;
  Timer initSpinTimer;
  bool isInitSpinTimerActive = false;
  Timer playerTimer;
  bool isPlayerTimerActive = false;

  int _currentLevel = 0;
  bool _gameRunning = true;
  var _level;



  bool _pause = false;
  /**
   * Constructor for the DartbladeGameController object
   * It creates a new view from DartBladeGameView and initilizes the model with the reference _player
   */
  DartbladeGameController(){
    _view = new DartBladeGameView();
    _model = new DartBladeGameModel(this);

    _player = new Blade(_view.center_x, _view.center_y, 25, _view, _model);
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
          _player.move(dx, dy);


        }
      }
    });


    _view.startButton.onClick.listen((e) {
      cancelTimers();
      _view.output.style.display = 'none';
      _view.game.style.display = 'block';


      _model.loadLevelInModel(_currentLevel).whenComplete(loadCurrentLevel);

    });

  }

  void loadCurrentLevel() {

    _level = _model.getMap();
    _view.fillLevelWithEntity(_level);
    buildCurrentLevel();

  }

  void buildCurrentLevel() {

    _player.position(_view.center_x, _view.center_y);
    cancelTimers();
    gameLoop();
  }

  void gameLoop () {

    if(!isInitSpinTimerActive){
      _view.getSpin.onClick.listen((ev) => handlegGtSpin());

    }
    if(!isPlayerTimerActive){
      _view.startLevel.onClick.listen((ev) => handleStartLevel());
      _view.spinDisplay.onClick.listen((ev) => handleSpinDisplay());
    }


    if(!isInitSpinTimerActive && !isPlayerTimerActive){
      _view.displayLevelFailed.onClick.listen((ev)  => handledisplayLevelFailed());
    }

  }
  void handlegGtSpin(){
    cancelTimers();
    isInitSpinTimerActive = true;
    initSpinTimer = new Timer.periodic(initSpinDurationSpeed, (_) {

      if (spinCount >= 1000000) spinCount = 0;
      spinCount = spinCount + 1000;
      _view.spinDisplay.text = "Spin: ${spinCount}";
      _player.spin = spinCount;
    });
    print(isInitSpinTimerActive);
    _view.getSpin.innerHtml ="Tap to start Spin | Tap on Spin to stop";
  }
  void handleSpinDisplay(){
    cancelTimers();
    _view.getSpin.style.display ="none";
    _view.startLevel.text = "Your SPin is: ${_player.spin} | click to start";
    _view.startLevel.style.display = "block";
  }
  void handleStartLevel(){
    cancelTimers();
    _model.initStartLevel();
    print("level verloren: ${ _model.leveLost}");
    _view.startLevel.style.display = "none";

    playerTimer = new Timer.periodic(playerTimerSpeed, (_) {
      isPlayerTimerActive = true;
      // Den Player Spin im Model updaten
      _player.spin = _player.spin - 1000;

      // Den Spin in der View anzeigen
      _view.spinDisplay.text = "Spin: ${_player.spin}";

      // Den playerTimer stoppen wenn der Spin auf 0 ist und Overlay
      // anzeigen, dass das Level verloren ist.
      // Den Player(Blade) im View updaten
      _view.update(_player);
      if(_player.spin <= 0) {
        playerTimer.cancel();
        _view.showLevelFailed(_currentLevel);
        _model.setLevelLost();
        print("level verloren: ${ _model.leveLost}");

      }

    });

  }

  void handledisplayLevelFailed(){
    cancelTimers();
    spinCount = 0;
    _player.spin = 0;
    _view.displayLevelFailed.style.display = "none";
    _view.getSpin.style.display = "block";

    gameLoop();


  }

  void cancelTimers(){
    if(initSpinTimer != null) {
      initSpinTimer.cancel();
    }
      if(playerTimer != null){
        playerTimer.cancel();
    }
  }











  /*
  /**
  Starts the game by hiding the menu and starting the initilizeSpin() method.
  Then the postion of the _player object is set to the center of the viewport.
   */

  void startNewGame(){
    stopAllTimer();
    _model.loadLevelInModel(_currentLevel).whenComplete(() =>initialiseSpin());

    // Aufruf der Methode um den Spin des Kreisels zu initialisieren


  }


  void updateLevel(List<List<TileTypes>> l ){
    _view.fillLevelWithEntity(l);
  }

  void startInitSpinTimer(){
    stopAllTimer();
    int spinCount = 0;
    if(!initSpinTimerActive) {
      initSpin = new Timer.periodic(initSPinSpeed, (initSpin) {
        initSpinTimerActive = true;
        if (spinCount >= 10) spinCount = 0;
        spinCount++;
        _view.spinDisplay.text = "Spin: ${spinCount}";
        _player.spin = spinCount;
      });
    }
  }

  // Den Spin des Kreisels initialisieren und das Spiel starten
  void initialiseSpin() {
    stopAllTimer();
    _level = _model.getMap();
    updateLevel(_level);

    _player.position(_view.center_x, _view.center_y);

    startInitSpinTimer();
    _view.spinDisplay.style.display = 'block';

    // Bei einem Klick auf das Spin-Feld wird der Spin-Timer beendet
    // und das Spiel wird gestartet
    _view.spinDisplay.onClick.listen((ev) {
      initSpin.cancel();
      initSpinTimerActive = false;
      stopAllTimer();
     // startPlayerTimer();
      gameLoop();

    });
  }

 /* void startPlayerTimer(){
      playerTimer = new Timer.periodic(new Duration(milliseconds: 50), (_) {
        playerTimerActive = true;
        _view.update(_player);
      });
  }
*/

  void gameLoop() {
    if (!spinTimerActive) {
      spinTimer = new Timer.periodic(spinTimerSpeed, (spinTimer) {
        spinTimerActive = true;
        _player.spin--;
        _view.spinDisplay.text = "Spin: ${_player.spin}";
        if(_player.spin <= 0){
          stopAllTimer();
          _view.showLevelFailed(_currentLevel);
        }
      });
    }
    if (!playerTimerActive) {
      playerTimer = new Timer.periodic(playerTimerSpeed, (playerTimer) {
        playerTimerActive = true;
        _view.update(_player);
      });
    }

    _view.displayLevelFailed.onClick.listen((e) {
         _view.displayLevelFailed.style.display = 'none';
         stopAllTimer();
         startNewGame();


    });
  }
/*
    if(playerDurationSpinTimerActive == false) {
      print("starte playerDurationSpinTimer");
      playerDurationSpin =
          Timer.periodic(new Duration(milliseconds: 2000), (_) {
            playerDurationSpinTimerActive = true;
            if (_player.spin > 0) {
              _player.spin--;
              _view.spinDisplay.text = "Spin: ${_player.spin}";
            }
            if (_player.spin <= 0) {
              print("stoppe playerDurationSpinTimer");
              playerDurationSpin.cancel();
              playerDurationSpinTimerActive = false;
              print("Stoppe playerTimer");
              playerTimer.cancel();
              playerTimerActive = false;
              _view.showLevelFailed(_currentLevel);

            }

          });

    }
    _view.displayLevelFailed.onClick.listen((ev) {
      _view.hideLevelFailed();
      initialiseSpin();
    });
    print("gameloop");

 */
  void stopAllTimer(){

    if(playerTimer != null) {
      playerTimer.cancel();
      playerTimerActive = false;
    }
      if(initSpin != null){
        initSpin.cancel();
        initSpinTimerActive = false;
      }
      if(spinTimer != null) {
        spinTimer.cancel();
        spinTimerActive =false;
      }
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


*/


}
