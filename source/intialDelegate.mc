import Toybox.Lang;
import Toybox.WatchUi;

class initialIntervalsDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    //! On a select event, start the intervals
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        WatchUi.pushView(new intervalsView(), null, WatchUi.SLIDE_DOWN);
        return true;
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_UP);
        return true;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new intervalsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}