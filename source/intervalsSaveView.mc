import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.ActivityRecording;

//! Save view
class SaveIntervalsView extends WatchUi.View {
    private var _session as Session?;

    //! Constructor
    public function initialize(session as Session) {
        View.initialize();

        _session = session;
    }

    public function getSession() as Session {
        return _session;
    }

    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.InitLayout(dc));
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) {
        View.onUpdate(dc);

        var prompt = View.findDrawableById("prompt") as Text;

        prompt.setText(Rez.Strings.prompt_save);
    }


}