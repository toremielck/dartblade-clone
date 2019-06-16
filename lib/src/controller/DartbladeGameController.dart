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
  var _level;
  int _lastLevel = 10;

  String playerInputSecret = "";

  /// Konstruktor für den [DartbladeGameController] - Es wird sowohl eine [_view]-Instanz,
  /// als auch eine Instanz des [_model] referenziert.
  /// Es wird ein neues [_player]-Objekt angelegt.
  ///
  /// Danach wird geprüft ob das Gerät im Landscape-Modul gehalten wird und entsprechend
  /// die Werte des Gyro-Sensors an die [_player.move(dx, dy)]-Funktion übergeben.
  DartbladeGameController(){
    _view = new DartBladeGameView();
    _model = new DartBladeGameModel(this);

    _player = new Blade(_view.center_x, _view.center_y, 25, _view, _model);
    window.onDeviceOrientation.listen((ev) {

      /// Es ist keine device orientation verfügbar. - Zeige entsprechenden Hinweis
      /// in der View an.
      if (ev.alpha == null && ev.beta == null && ev.gamma == null) {
        _view.displayUseSmartphone.style.display = 'block'; // Show QR code
      }

      /// Device orientation ist verfügbar. - Lasse die Hinweise in der View verschwinden
      /// und rufe die [_player.move()]-Funktion mit den Bewegungs-Werten des Sensors auf.
      else {
        _view.displayUseSmartphone.style.display = 'none'; // Hide QR code
        if (_view.getLandscapeMode(_view.width, _view.height) == false) {
          _view.changeView.style.display = 'block';
        } else {
          _view.changeView.style.display = 'none';

          final dx = min(20, max(-20, ev.beta));
          final dy = min(-20, max(-80, ev.gamma)) + 50;

          _player.move(dx, dy);

        }
      }
    });

    /// Warten auf ein Klick-Event zum Starten des Spiels.
    _view.startButton.onClick.listen((e) {
      cancelTimers();
      _view.output.style.display = 'none';
      _view.game.style.display = 'block';

      /// Das aktuelle Level laden und bei Fertigstellung die loadCurrentLevel()-
      /// Funktion aufrufen.
      _model.loadLevelInModel(_currentLevel).whenComplete(loadCurrentLevel);

    });

    _view.enterSecretButton.onClick.listen((e){
      _view.showEnterSecretField();
      _view.secretEntered.onClick.listen((ev) => handleSecret());

    });

    _view.instructions.onClick.listen((e){
      _view.showInstructiontext();
      _view.instructionsText.onClick.listen((e) => _view.hideInstructionText());
    });

  }
  void handleSecret(){
    String  secretValue = ((document.querySelector('#secretField') as TextInputElement).value).toString();
    int levelNumberFromSecret = _model.getLevelNumberFromLevelSecret(secretValue);
    if( levelNumberFromSecret > -1){
      _currentLevel = levelNumberFromSecret;
      _view.output.style.display = 'none';
      _view.game.style.display = 'block';

      _model.loadLevelInModel(_currentLevel).whenComplete(loadCurrentLevel);
    }
    else{

    }
  }

  /// Erstellt das vorher geladene Level.
  void loadCurrentLevel() {

    // Setzt die Position des Levels wieder auf die Startposition.
    resetLevelPosition();

    _level = _model.getMap();

    /// Das HTML-Element, welches als Level genutzt wird mit den vorher geladenen
    /// Tiles füllen.
    _view.fillLevelWithEntity(_level);

    /// Start des Spiels. Der Player kan sich bewegen.
    buildCurrentLevel();

  }

  void buildCurrentLevel() {

    /// Die Position des Players auf den Center des Viewports legen.
    _player.position(_view.center_x, _view.center_y);

    /// Alle Timer beenden.
    cancelTimers();

    _model.initStartLevel();
    /// Start des Game-Loops
    gameLoop();
  }

  /// Haupt Game-Loop hier wird abgefragt, ob die Variblaen [isInitSpinTimerActive],
  /// [isPlayerTimerActive] und eine UND-Bedingung beider aktiv sind.
  /// Je nachdem, welcher der Satus aktiv ist wird ein onClick.listen() Event
  /// an ein Objekt in der View angehängt. Dieses wartet dann auf seine Aktivierung
  /// und startet die entsprechende Handler-Funktion.
  void gameLoop () {

    if(!isInitSpinTimerActive){
      _view.getSpin.onClick.listen((ev) => handlegGetSpin());

    }
    if(!isPlayerTimerActive){
      _view.startLevel.onClick.listen((ev) => handleStartLevel());
      _view.spinDisplay.onClick.listen((ev) => handleSpinDisplay());
    }


    if(!isInitSpinTimerActive && !isPlayerTimerActive){
      _view.displayLevelFailed.onClick.listen((ev)  => handledisplayLevelFailed());
      _view.displayLevelFinished.onClick.listen((ev) => handleDisplayLevelFinished());
    }

  }

  /// Ist dafür zuständig den Spin immer hoch und wieder runter laufen zu lassen
  /// und dem Player den entsprechenden Spin zuzuweisen.
  void handlegGetSpin(){

    /// Alle Timer beenden
    cancelTimers();

    isInitSpinTimerActive = true;

    /// Zählen und anzeigen des Spins
    initSpinTimer = new Timer.periodic(initSpinDurationSpeed, (_) {

      if (spinCount >= 100000) spinCount = 0;
      spinCount = spinCount + 1000;
      _view.spinDisplay.text = "Spin: ${spinCount} (rpm)";
      _player.spin = spinCount;

    });

    /// Overlay zum Starten des Spiels in der View anzeigen
    _view.getSpin.innerHtml ="Tap to start Spin | Tap on Spin to stop";
  }

  /// Ausblenden des Overlays, welches zum wählen des Spins auffordert und
  /// einblenden des Overlays, welches anzeigt, wieviel Spin man bekommen hat.
  void handleSpinDisplay(){

    /// Alle Timer Beenden
    cancelTimers();

    _view.getSpin.style.display ="none";
    _view.startLevel.text = "Your Spin is: ${_player.spin} | tap to start";
    _view.startLevel.style.display = "block";
  }

  /// Zeigt das Player-Objekt in der View an und startet den Timer, welcher für
  /// den Player verantwortlich ist. Dieser updatet im gegebenem Intervall des Spin
  /// des Players und fragt sowohl Sieg, als auch Lost-Bedingung ab.
  /// Sollte die Lost Bedingung erreicht sein (der Player hat keinen Spin mehr)
  /// oder der Player fällt von der Spielplattform wird das Level neu gestartet.
  /// Andernfalls (beim erreichen des Goal-Tiles) wird das nächste Level neu geladen.
  void handleStartLevel(){
    /// Alle Timer beenden

    cancelTimers();
    _model.initStartLevel();
    _view.blade.style.display = "block";



    _view.startLevel.style.display = "none";

    /// Dieser Timer updatet intervallgesteuert den Spin des Players und prüft
    /// auf Sieg- oder Lost-Bedingung
    playerTimer = new Timer.periodic(playerTimerSpeed, (_) {
      isPlayerTimerActive = true;

      // Den Player Spin im Model updaten
      _player.spin = _player.spin - 100;

      // Den Spin in der View anzeigen
      _view.spinDisplay.text = "Spin: ${_player.spin} (rpm)";

      // Den Player(Blade) im View updaten
      _view.update(_player);

      /// Der Spin des Players ist auf 0 und man hat verloren.
      if(_player.spin <= 0 || (_model.leveLost && (_model.gameoverTrigger > 0))) {
        _view.blade.style.display = "none";

        /// Die Position des Spielers wieder auf den Mittelpunkt des Vieports
        /// legen, damit dieser beim erneuten Starten des Siels nicht auf der
        /// Position bleibt woer beim Beenden des Levels war.
        resetPlayerPositiontoCenter();

        /// Den playerTimer stoppen wenn der Spin auf 0 ist und Overlay
        /// anzeigen, dass das Level verloren ist. Außerdem im Model anzeigen,
        /// dass das Level verloren wurde.
        playerTimer.cancel();
        _view.showLevelFailed(_currentLevel);
      }


      /// Man hat das Goal-Tile erreicht und das Level ist gewonnen.
      if(_model.levelWon){

        /// Ausblenden des Players bis zum Start des nächsten Levels.
        _view.blade.style.display = "none";

        /// Die Position des Spielers wieder auf den Mittelpunkt des Vieports
        /// legen, damit dieser beim erneuten Starten des Siels nicht auf der
        /// Position bleibt woer beim Beenden des Levels war.
        resetPlayerPositiontoCenter();

        /// Den Timer für den Player stoppen.
        playerTimer.cancel();

        /// In der View anzeigen, dass das aktuelle Level gewonnen wurde und
        /// das entsprechende Level-Secret hierfür darstellen.
        /// Auf diese Weise (Level-Secret) kann ein Spieler später wieder dort
        /// weiterspielen, wo er aufgehört hat.
        _view.showLevelFinished(_model.currentLevel, _model.levelSecret);

        /// Die Nummer des aktuellen Levels um 1 erhöhen, damit man beim erneuten
        /// Staten des Spiels in das nächste Level kommt.
        _currentLevel++;
      }
    });
  }

  /// Wird aufgerufen, sobald man ein Level verloren hat und dieses durch einen
  /// Klick auf das entsprechende Overlay neu starten möchte.
  /// Es wird der [spinCount] auf 0 gesetzt, um Den [spinCount] wieder hoch und
  /// runter zählen lassen zu können. Außerdem wird der [_player.spin] auf 0 gesetzt,
  /// damit dieser nicht beim erneuten Starten des Levels schon einen Wert besitzt.
  void handledisplayLevelFailed() async {

    /// Alle Timer beenden
    cancelTimers();

    spinCount = 0;
    _player.spin = 0;

    /// In der View wird ein Overlay angezeigt, dass man das Level verloren hat
    /// und es durch einen Klick auf dieses Overlay nochmal probieren kann.
    _view.displayLevelFailed.style.display = "none";
    _view.getSpin.style.display = "block";

    /// Lade das aktuelle Level neu. Hierzu wird das Level vollständig neu
    /// über JSON in das Model eingelesen und dann auch alle Variablen durch
    /// loadCurrentLevel() neu gesetzt. Dies soll verhindern, dass eventuelle
    /// Werte von vorherigen Durchläufen nicht wieder zurückgesetzt werden.
    if(_currentLevel <= _lastLevel){

      await _model.loadLevelInModel(_currentLevel);

      _view.getSpin.style.display ="block";
      loadCurrentLevel();

    }

  }


  /// Sollte die Sieg-Bedingung des Levels erfüllt werden werden auch hier genau
  /// wie beim erneuten Spielen eines Levels, durch erfülte Lost-Bedingung
  /// alle Variablen neu gesetzt und das Level per JSON vollständig neu geladen.
  void handleDisplayLevelFinished() async{

    /// Alle Timer beenden.
    cancelTimers();
    spinCount = 0;
    _player.spin = 0;
    _model.gameoverTrigger = -1;
    _view.displayLevelFinished.style.display ="none";

    if(_currentLevel <= _lastLevel){

      await _model.loadLevelInModel(_currentLevel);

      _view.getSpin.style.display ="block";
      loadCurrentLevel();

    }

  }

  /// Die Position des Players auf den Center des Viewports setzen und dann die
  /// View updaten. - Diese Funktion wird benötigt unm zwischen des Levels den
  /// Player wieder auf seine Start-Position zu bringen.
  void resetPlayerPositiontoCenter(){
    _player.position(_view.center_x, _view.center_y);
    _view.update(_player);

  }

  /// Setzt die Position des Levels wieder auf die Startposition. - Dies wird
  /// benötigt um zwischen dem Laden der Levels nicht die alte Position des Levels
  /// aus dem vorherigen Spiel zu übernehmen.
  void resetLevelPosition(){
    _view.level.innerHtml = "";
    _view.level.style.top = "0px";
    _view.level.style.right = "0px";
    _view.levelPositionTop = 0;
    _view.levelPositionRight = 0;
  }

  /// Beendet den [initSpinTimer] und den [playerTimer].
  void cancelTimers(){
    if(initSpinTimer != null) {
      initSpinTimer.cancel();
    }
      if(playerTimer != null){
        playerTimer.cancel();
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
}
