import Toybox.Lang;
import Toybox.WatchUi;

class SaveIntervalsDelegate extends WatchUi.BehaviorDelegate {
    private var _parentView as SaveIntervalsView;


    function initialize(view as SaveIntervalsView) {
        BehaviorDelegate.initialize();

        _parentView = view;
    }

    //! On a select event, start the intervals
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        _parentView.getSession().save();
        WatchUi.popView(WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle back behavior
    //! @return true if handled, false otherwise
    public function onBack() as Boolean {
        _parentView.getSession().discard();
        WatchUi.popView(WatchUi.SLIDE_UP);
        return true;
    }
}