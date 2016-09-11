import 'dart:html';
import 'dart:async';
import 'package:angular2/angular2.dart';

@Directive(selector: "[vuScrollDown]")
class VuScrollDown {
  final ElementRef _ref;
  Element _el;

  MutationObserver _mo;

  Map<StreamSubscription, bool> loadSubs = {};

  VuScrollDown(ElementRef this._ref) {
    _el = _ref.nativeElement;
    _mo = new MutationObserver(_mutation);
    _mo.observe(_el, childList: true);
  }

  void _mutation(List<MutationRecord> mutations, MutationObserver observer) {
    for (MutationRecord mutation in mutations) {
      for (Node node in mutation.addedNodes) {
        if (node is Element) {
          ElementList images = node.querySelectorAll("img");

          for (ImageElement img in images) {
            StreamSubscription loadSub;
            loadSub = img.onLoad.listen((_) {
              _scrollToBottom();

              if (loadSubs.containsKey(loadSub)) {
                loadSub.cancel();
                loadSubs.remove(loadSub);
              }
            });

            loadSubs[loadSub] = true;
          }
        }
      }
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    _el.scrollTop = _el.scrollHeight;
  }
}