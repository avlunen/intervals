import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Application.Properties;
import Toybox.Application.Storage;

class MyNumberPickerView extends WatchUi.View {
    private var myValue as Number = 0;

    //! Constructor
    public function initialize() {
        View.initialize();

        var store = Storage.getValue("intervals_no");
        
        if(store == null) {
            myValue = 0;
        }
        else {
            myValue = store.toNumber();
        }

    }

    public function setMyValue(val as Number) as Void {
        myValue = val;
    }

    public function getMyValue() as Number {
        return myValue;
    }

    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.NumberPicker(dc));
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) {
        var prompt = View.findDrawableById("myvalue") as Text;

        prompt.setText(myValue.toString());

        View.onUpdate(dc);
        //prompt.setText(Lang.format("$1$:$2$", [(myValue/60).format("%02d"), (myValue%60).format("%02d")]));
    }


}