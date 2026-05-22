import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application.Properties;

class MyIntervalLengthPickerDelegate extends WatchUi.BehaviorDelegate {
    private var myvalue as Number = 0;
    private var _parentView as MyIntervalLengthPickerView;

    function getValue() as Number {
        return myvalue;
    }

    function initialize(view as  MyIntervalLengthPickerView) {
        BehaviorDelegate.initialize();

        _parentView = view;

        myvalue = _parentView.getMyValue();
    }

    function onNextPage() as Boolean {  // Down, which seems counter-intutitive

        if(myvalue > 0) {
            myvalue-=15;
        }
        else {
            myvalue = 0;
        }

        _parentView.setMyValue(myvalue);

        WatchUi.requestUpdate();

        return true;
    }

    function onPreviousPage() as Boolean { // Up

        if(myvalue < 5940) { // let's keep it to 99mins
            myvalue+=15;
        }
        
        _parentView.setMyValue(myvalue);

        WatchUi.requestUpdate();

        return true;
    }

    function onSelect() {
        Storage.setValue("intervals", myvalue);

        WatchUi.popView(WatchUi.SLIDE_UP);

        return true;
    }
}