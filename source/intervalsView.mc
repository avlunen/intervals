import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.Attention;
import Toybox.Application.Storage;
import Toybox.ActivityRecording;

class intervalsView extends WatchUi.View {
    private var _count1 as Number = 0;
    private var _count2 as Number = 0;
    private var _int_cnt as Number = 0;
    private var _hrString as String;
    private var _timer1 as Timer.Timer?;
    private var _timer2 as Timer.Timer?;
    private var _radius as Number = 28;
    private var _int_length as Number = 30; // interval length in seconds
    private var _int_pause as Number = 15; // pause between intervals in seconds
    private var _intervals as Number = 5; // number of intervals
    private var _vibeEndData = [ new Attention.VibeProfile(100, 2000) ]; // On for one second
    private var _vibeStartData = [ new Attention.VibeProfile(100, 400), 
                                    new Attention.VibeProfile(0, 100),
                                    new Attention.VibeProfile(100, 400) ]; // two shorter vibes
    private var _isTimer1 as Boolean = true;
    private var _session as Session?;

    function initialize() {
        View.initialize();

        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents(method(:onSnsr));

        if (Toybox has :ActivityRecording) {
            _session = ActivityRecording.createSession({:name=>"Intervals", :sport=>Activity.SPORT_GRINDING, 
                :subSport=>Activity.SUB_SPORT_INDOOR_GRINDING});
        }

        // check if values are stored on watch
        var store_p = Storage.getValue("pause");
        var store_i = Storage.getValue("intervals");
        var store_n = Storage.getValue("intervals_no");

        if(store_i != null) {
            _int_length = store_i.toNumber();
        }

        if(store_p != null) {
            _int_pause = store_p.toNumber();
        }

        if(store_n != null) {
            _intervals = store_n.toNumber();
        }

        _hrString = "--- bpm";

        // we want to count down, so init the counters with the max values
        _count1 = _int_length;
        _count2 = _int_pause;
        _int_cnt = _intervals;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        if (_timer1 == null) {
            _timer1 = new Timer.Timer();
            _timer1.start(self.method(:onTimer1), 1000, true);

            if (Attention has :vibrate) {
                Attention.vibrate(_vibeStartData);
            }
        }

        if (_timer2 == null) {
            _timer2 = new Timer.Timer();
        }
        
        if(_session != null) {
            _session.start();
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var view_time = View.findDrawableById("TimeLabel") as Text;
        var view_status = View.findDrawableById("StatusLabel") as Text;
        var view_heart = View.findDrawableById("HeartLabel") as Text;
        var view_counter = View.findDrawableById("CountLabel") as Text;


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // display timers
        if(_isTimer1 == true) {
            view_time.setText(Lang.format("$1$:$2$", [(_count1/60).format("%02d"), (_count1%60).format("%02d")]));
            view_status.setText(Rez.Strings.interval);
        }
        else {
            view_time.setText(Lang.format("$1$:$2$", [(_count2/60).format("%02d"), (_count2%60).format("%02d")]));
            view_status.setText(Rez.Strings.int_pause);
        }

        // display heart rate
        view_heart.setText(_hrString);
        
        // display interval number
        if(_int_cnt < _intervals) {
            view_counter.setText(_int_cnt.toString());
        }
        else {
            view_counter.setText(_intervals.toString());       
        }

        // paint progress bar
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(6);

        if(_count1 < _int_length && _isTimer1 == true) {
            dc.drawArc(144, 31, _radius, Graphics.ARC_COUNTER_CLOCKWISE, 0, Math.round((360/_int_length)*(_count1)).toNumber());
        }
        else if(_count2 < _int_pause && _isTimer1 == false) {
            dc.drawArc(144, 31, _radius, Graphics.ARC_COUNTER_CLOCKWISE, 0, Math.round((360/_int_pause)*(_count2)).toNumber());
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        if (_timer1 != null) {
            _timer1.stop();
            _timer1 = null;
        }
        if (_timer2 != null) {
            _timer2.stop();
            _timer2 = null;
        }

        if(_session != null) {
            _session.stop();
        }

        _isTimer1 = true;

        _count1 = _int_length;
        _count2 = _int_pause;
        _int_cnt = _intervals;
    }

    // Timer for interval, called every second
    function onTimer1() as Void {
        _count1--;


        if(_count1 <= 0) {
            _count1 = _int_length;
            _isTimer1 = false;

            _timer1.stop();
            _timer2.start(self.method(:onTimer2), 1000, true);

            // Play a predefined tone
            if (Attention has :vibrate) {
                Attention.vibrate(_vibeStartData);
            }

        }
        
        WatchUi.requestUpdate();
    }

    // Timer for pause, called every second
    function onTimer2() as Void {
        _count2--;


        if(_count2 <= 0) { // pause over
            _int_cnt--;
            _count2 = _int_pause;
            _isTimer1 = true;

            if(_int_cnt <= 0) { // done
                if (_timer1 != null) {
                    _timer1.stop();
                }

                if (_timer2 != null) {
                    _timer2.stop();
                }

                if (Attention has :vibrate) {
                    Attention.vibrate(_vibeEndData);
                }
/*
                if(_session != null) {
                    _session.stop();
                }
*/
                var view = new SaveIntervalsView(_session);
                var del = new SaveIntervalsDelegate(view);
                WatchUi.switchToView(view, del, WatchUi.SLIDE_DOWN);
            }
            else {
                _timer2.stop();
                _timer1.start(self.method(:onTimer1), 1000, true);

                // Play a predefined tone
                if (Attention has :vibrate) {
                    Attention.vibrate(_vibeStartData);
                }
            }
        }

        WatchUi.requestUpdate();
    }

    //! Handle sensor updates
    //! @param sensorInfo Updated sensor data
    public function onSnsr(sensorInfo as Info) as Void {
        var heartRate = sensorInfo.heartRate;

        if (heartRate != null) {
            _hrString = heartRate.toString() + " bpm";
        }
        else {
            _hrString = "--- bpm";
        }

        WatchUi.requestUpdate();
    }

}
