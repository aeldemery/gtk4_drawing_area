namespace DemoApp {
public class DemoApp : Gtk.Application {
    public DemoApp () {
        Object (
            application_id: "github.aeldemery.gtk4_drawing_area_demo",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate () {
        var win = new DemoWindow(this);
        win.destroy_with_parent = true;
        win.present();
    }
}

public class DemoWindow: Gtk.ApplicationWindow {
    private Gtk.GestureDrag drag;
    private Gtk.GestureClick press;

    private Gtk.Frame frame;

    private Gtk.DrawingArea drawing_area;
    static Cairo.Surface surface = null;

    static double start_x;
    static double start_y;
    
    public DemoWindow (Gtk.Application app) {
        Object (application: app);
        this.set_title ("Gtk4 Drawing Area Example");

        frame = new Gtk.Frame ("Drawing Area");
        this.set_child (frame);
        
        drawing_area = new Gtk.DrawingArea ();
        drawing_area.set_size_request (400, 300);

        frame.set_child (drawing_area);
        //drawing_area.set_draw_func (draw_cb);
        drawing_area.realize.connect ( (area) => {
            init_drawing_area (area as Gtk.DrawingArea);
        });
        drawing_area.resize.connect ( (area, width, height) => {
            init_drawing_area (area);
        });
        drawing_area.set_draw_func ( (area, context, width, height) => {
            context.set_source_surface (surface, 0, 0);
            context.paint ();
        });
        
        drag = new Gtk.GestureDrag ();
        drag.set_button (Gdk.BUTTON_PRIMARY);
        drawing_area.add_controller (drag);
        drag.drag_begin.connect ( (widget, x, y) => {
            start_x = x;
            start_y = y;
            
            draw_brush (widget, x, y);
        });
        drag.drag_update.connect ( (gesture, offset_x, offset_y) => {
            draw_brush (gesture, start_x + offset_x, start_y + offset_y);
        });
        drag.drag_end.connect ( (gesture, offset_x, offset_y) => {
            draw_brush (gesture, start_x + offset_x, start_y + offset_y);
        });

        press = new Gtk.GestureClick ();
        press.set_button (Gdk.BUTTON_SECONDARY);
        drawing_area.add_controller (press);
        press.pressed.connect ( (gesture, n_press, x, y) => {
            clear_surface ();
            gesture.get_widget ().queue_draw ();
        });

        this.show ();
    }

    private void draw_brush (Gtk.GestureDrag area, double x, double y) {
        var cr = new Cairo.Context (surface);
        cr.rectangle (x - 3, y - 3, 6, 6);
        cr.fill ();
        area.get_widget ().queue_draw ();
    }

    private void init_drawing_area (Gtk.DrawingArea area) {
        var gdk_surface = area.get_native().get_surface();
        if (gdk_surface != null) {
            surface = gdk_surface.create_similar_surface (
                Cairo.Content.COLOR, area.get_width (), area.get_height ()
            );
            clear_surface ();
        }
    }

    private void clear_surface () {
        var cr = new Cairo.Context (surface);
        cr.set_source_rgb (1, 1, 1);
        cr.paint ();
    }
}
int main (string[] args) {
    var app = new DemoApp();
    var result = app.run(args);
    return result;
}
}
