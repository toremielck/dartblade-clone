part of modelLib;

class Level {

  Level(levelNumber) {
    this.generateLevelFromJSON(levelNumber);
  }

  // Position des Levels
  int _position_x;
  int _position_y;

  // Größe des Levels
  int _size_x;
  int _size_y;

  int _levelNumber;
  String _levelSecret;

  // Struktur des Levels kodiert als einzelne Tiles
  String _levelStructur;

  // Die JSON-Level-Datei abholen und den Inhalt der JSON-Datei in die Level-Variablen schreiben.
  // Dann werden die einzelnen Symbole der level.json Datei in HTML-Divs umgesetzt
  // mit Hilfe der writeLevelStrctureToHTML()-Methode. Dies erfolgt alles asynchron.
  // Deshalb auch der Rückhabewert Future<bool>
  Future<bool> generateLevelFromJSON(levelNumber) async {

    try {

      await HttpRequest.getString("/levels/level_${levelNumber}.json").then((String requestResult) {

      var levelData = jsonDecode(requestResult);

      _levelNumber = levelData["levelNumber"];
      _levelSecret = levelData["levelSecret"];
      _size_x = levelData["size_x"];
      _size_y = levelData["size_y"];
      _levelStructur = levelData["levelStructur"];

      });

      await writeLevelStructureToHTML(_levelStructur);

      return true;

    } catch (e) {
      print("generateLevelFromJSON Error: ${e}");
      return false;
    }
  }

  Future<bool> writeLevelStructureToHTML(String levelStructur) async {

    // Das HTML-Element mit der id "level" auswählen und in Konstante abspeichern
    // um es mit den Tiles zu befüllen
    // TODO: muss hier nicht irgendwie eine Verknüpfung zu dem Objekt aus der View
    // TODO: her? Ich meine, man befüllt schließlich ein Element der View.
    final levelDiv = document.querySelector("#level");

    levelStructur.runes.forEach((rune) {

      // Holt sich den jeweiligen Buchstaben aus der levelStrctur
      String tile = new String.fromCharCode(rune);

      // Hier wird wird geprüft um welches Symbol es sich gerade handelt
      // und dem entsprechend die einzelnen Tiles (divs) in das Level eingefügt.
      switch (tile) {
          // Leer-Tiles
        case 'X':
          var tileDiv = new DivElement();
          tileDiv.className = "td border-tile";
          tileDiv.setAttribute("tileType", "border-tile");
          levelDiv.children.add(tileDiv);
          break;
          // Normal-Tiles
        case '#':
          var tileDiv = new DivElement();
          tileDiv.className = "td background-water";
          tileDiv.setAttribute("tileType", "water-tile");
          levelDiv.children.add(tileDiv);
          break;
          // Spin-Tiles
        case '~':
          var tileDiv = new DivElement();
          tileDiv.className = "td background-shake";
          tileDiv.setAttribute("tileType", "shake-tile");
          levelDiv.children.add(tileDiv);
          break;
          // Row-Tiles (!Sondefall: verursacht einen break in der Level-Struktur)
          // so wie in HTML <br>
        case '|':
          var rowDiv = new DivElement();
          rowDiv.className = "tr";
          levelDiv.children.add(rowDiv);
          break;
        default:
          print("Symbol für Tile nicht erkannt!");
          break;
      }
    });
  }
}