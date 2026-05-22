import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application.Properties;

class MyNumberPickerDelegate extends WatchUi.BehaviorDelegate {
    private var myvalue as Number = 0;
    private var _parentView as MyNumberPickerView;

    function getValue() as Number {
        return myvalue;
    }

    function initialize(view as  MyNumberPickerView) {
        BehaviorDelegate.initialize();

        _parentView = view;

        myvalue = _parentView.getMyValue();
    }

    function onNextPage() as Boolean {  // Down, which seems counter-intutitive

        if(myvalue > 0) {
            myvalue--;
        }
        else {
            myvalue = 0;
        }

        _parentView.setMyValue(myvalue);

        WatchUi.requestUpdate();

        return true;
    }

    function onPreviousPage() as Boolean { // Up

        if(myvalue < 100) {
            myvalue++;
        }
        
        _parentView.setMyValue(myvalue);

        WatchUi.requestUpdate();

        return true;
    }

    function onSelect() {
        Storage.setValue("intervals_no", myvalue);

        WatchUi.popView(WatchUi.SLIDE_UP);

        return true;
    }
}