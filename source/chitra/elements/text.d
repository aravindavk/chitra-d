module chitra.elements.text;

import std.format;
import std.string;

import chitra.context;
import chitra.properties;
import chitra.elements.core;
import chitra.elements.formatted_strings;
import chitra.rgba;

struct Text
{
    FormattedString txt;
    double x_, y_;
    double w_, h_;
    ShapeProperties shapeProps;
    TextProperties textProps;

    this(FormattedString txt, double x, double y, double w, double h)
    {
        this.txt = txt;
        this.x_ = x;
        this.y_ = y;
        this.w_ = w;
        this.h_ = h;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        cairo_save(cairoCtx);
        // Do not use fill color since the text color will be added
        shapeProps.fill = RGBA(0, 0, 0, 0);
        cairo_set_antialias(cairoCtx, CAIRO_ANTIALIAS_BEST);
        cairo_move_to(cairoCtx, x, y);
        auto layout = pango_cairo_create_layout(cairoCtx);
        pango_layout_set_markup(layout, txt.content(chitraCtx).toStringz, -1);
        pango_cairo_update_layout(cairoCtx, layout);
        pango_cairo_show_layout(cairoCtx, layout);
        pango_cairo_layout_path(cairoCtx, layout);

        if (shapeProps.strokeWidth > 0 && !shapeProps.noStroke)
            drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
        else
            cairo_new_path(cairoCtx);

        cairo_restore(cairoCtx);
        g_object_unref(layout);
    }

    Box size(Context chitraCtx, cairo_t* cairoCtx)
    {
        cairo_save(cairoCtx);
        // Do not use fill color since the text color will be added
        cairo_set_antialias(cairoCtx, CAIRO_ANTIALIAS_BEST);
        cairo_move_to(cairoCtx, x_, y_);
        auto layout = pango_cairo_create_layout(cairoCtx);
        if (w_ > 0)
            pango_layout_set_width(layout, cast(int)(w_ * PANGO_SCALE));

        if (h_ > 0)
            pango_layout_set_height(layout, cast(int)(h_ * PANGO_SCALE));

        pango_layout_set_markup(layout, txt.content(chitraCtx).toStringz, -1);
        pango_cairo_update_layout(cairoCtx, layout);
        pango_cairo_show_layout(cairoCtx, layout);
        pango_cairo_layout_path(cairoCtx, layout);

        if (shapeProps.strokeWidth > 0 && !shapeProps.noStroke)
            drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
        else
            cairo_new_path(cairoCtx);

        int w, h;
        pango_layout_get_size(layout, &w, &h);

        cairo_restore(cairoCtx);
        g_object_unref(layout);

        return Box(x_, y_, (cast(double)w) / PANGO_SCALE, (cast(double)h) / PANGO_SCALE);
    }
}

mixin template textFunctions()
{
    /**
       Draw the text.

       ---
       ctx.text("Hello World!", 100, 100);
       ---
     */
    void text(string txt, double x, double y, double w = 0.0, double h = 0.0)
    {
        auto formatted = FormattedString(txt);
        text(formatted, x, y, w, h);
    }

    void text(FormattedString txt, double x, double y, double w = 0.0, double h = 0.0)
    {
        auto props = updateProperties([defaultTextProperties, this.textProps, txt.currentProperties]);
        txt.currentProperties = props;
        auto s = Text(txt, x, y, w, h);
        // Copy only top level props
        s.textProps = props;
        s.shapeProps = this.shapeProps;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
    }

    void text(string txt, Box cell)
    {
        text(txt, cell.x, cell.y, cell.width, cell.height);
    }

    void text(FormattedString txt, Box cell)
    {
        text(txt, cell.x, cell.y, cell.width, cell.height);
    }

    Box textSize(string txt, double w = 0.0, double h = 0.0)
    {
        auto formatted = FormattedString(txt);
        return textSize(formatted, w, h);
    }

    Box textSize(FormattedString txt, double w = 0.0, double h = 0.0)
    {
        auto props = updateProperties([defaultTextProperties, this.textProps, txt.currentProperties]);
        txt.currentProperties = props;
        auto s = Text(txt, 0, 0, w, h);
        // Copy only top level props
        s.textProps = props;
        s.shapeProps = this.shapeProps;
        return s.size(this, this.defaultCairoCtx);
    }
}
