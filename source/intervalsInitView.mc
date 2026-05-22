import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

//! Initial view
class InitialWatchView extends WatchUi.View {

    //! Constructor
    public function initialize() {
        View.initialize();
    }

    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.InitLayout(dc));
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) {
        View.onUpdate(dc);

        var prompt = View.findDrawableById("prompt") as Text;

        prompt.setText(Rez.Strings.prompt);
    }

}