import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class intervalsMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            var view = new MyIntervalLengthPickerView();
            var picker = new MyIntervalLengthPickerDelegate(view);
            WatchUi.pushView(view, picker, WatchUi.SLIDE_UP);
        }
        else if (item == :item_2) {
            var view = new MyPauseLengthPickerView();
            var picker = new MyPauseLengthPickerDelegate(view);
            WatchUi.pushView(view, picker, WatchUi.SLIDE_UP);
        }
        else if (item == :item_3) {
            var view = new MyNumberPickerView();
            var picker = new MyNumberPickerDelegate(view);
            WatchUi.pushView(view, picker, WatchUi.SLIDE_UP);
        }
    }
}