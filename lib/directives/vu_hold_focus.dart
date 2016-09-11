import 'dart:html';
import 'package:angular2/angular2.dart';

@Directive(selector: "[vuHoldFocus]")
class VuHoldFocus {
  final ElementRef _ref;
  Element _el;

  VuHoldFocus(ElementRef this._ref) {
    _el = _ref.nativeElement;
  }

  @HostListener('blur')
  void onBlur() {
    _el.focus();
  }
}