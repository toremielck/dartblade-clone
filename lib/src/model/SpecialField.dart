part of modelLib;

abstract class SpecialField extends Entity{

  bool _isVisible = false;

  DartBladeGameModel _model;

  SpecialField(double x, double y, bool collision, this._isVisible, this._model)
    : super(x, y, collision){

  }

  void _onField(){
    if(_isVisible){
      _isVisible = false;
    }
  }

}