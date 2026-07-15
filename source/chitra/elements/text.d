module chitra.elements.text;

import std.format;
import std.string;
import std.array;

import chitra.context;
import chitra.properties;
import chitra.elements.core;
import chitra.elements.formatted_strings;
import chitra.rgba;
import chitra.elements.markup_tokens;
import chitra.helpers : Size, Box;

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

    Token readyToDraw(Context chitraCtx, string fullMarkup, double w, double h)
    {
        if (w == 0 && h == 0)
            return Token(fullMarkup, "");

        // Check if the height of the rendered text is less than the given height
        // If height not fits, then convert the Markup text to plain text, so that
        // word by word we can check the textSize and then render.
        auto box = size(chitraCtx, chitraCtx.defaultCairoCtx, fullMarkup, w, h);
        if (box.height <= h)
            return Token(fullMarkup, "");

        Token outToken;
        auto tokens = MarkupToken(fullMarkup);
        while (true)
        {
            auto token = tokens.get;
            auto box1 = size(chitraCtx, chitraCtx.defaultCairoCtx, token.part, w, h);
            // If the text height is more than the given height, check
            // if the text till prev word covers the bounding box.
            if (box1.height > h)
            {
                auto prevToken = tokens.getPrev;
                auto box2 = size(chitraCtx, chitraCtx.defaultCairoCtx, prevToken.part, w, h);
                // Till Prev word the text is covered, So this
                // the max we can render
                if (box2.height <= h)
                {
                    outToken = prevToken;
                    break;
                }

                // Both the text till current and Prev word is high than
                // the bounding box. Mark it as High, so that Tokens stream
                // can continue search (Binary search).
                tokens.notOkHigh;
            }
            else
            {
                auto nextToken = tokens.getNext;
                auto box2 = size(chitraCtx, chitraCtx.defaultCairoCtx, nextToken.part, w, h);
                // Current word is covered and the next word we
                // can't cover, so this is the max we can render.
                if (box2.height >= h)
                {
                    outToken = token;
                    break;
                }

                // Both the text till current and Next word is low than
                // the bounding box. Mark it as Low, so that Tokens stream
                // can continue search (Binary search).
                tokens.notOkLow;
            }
        }

        return outToken;
    }

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
        auto x = chitraCtx.correctedSize(x_);
        auto y = chitraCtx.correctedSize(y_);
        auto w = chitraCtx.correctedSize(w_);
        auto h = chitraCtx.correctedSize(h_);

        cairo_save(cairoCtx);
        // Do not use fill color since the text color will be added
        shapeProps.fill = RGBA(0, 0, 0, 0);
        cairo_set_antialias(cairoCtx, CAIRO_ANTIALIAS_BEST);
        cairo_move_to(cairoCtx, x, y);
        auto layout = pango_cairo_create_layout(cairoCtx);

        if (w > 0)
            pango_layout_set_width(layout, cast(int)w * PANGO_SCALE);

        if (h > 0)
            pango_layout_set_height(layout, cast(int)h * PANGO_SCALE);

        auto fullMarkup = txt.content(chitraCtx);

        // TODO: Add hyphenation function
        // pango_layout_set_wrap(layout, PANGO_WRAP_CHAR);

        auto token = readyToDraw(chitraCtx, fullMarkup, w, h);
        pango_layout_set_markup(layout, token.part.toStringz, -1);
        chitraCtx.overflowMarkup_ = token.rest;

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

    Size size(Context chitraCtx, cairo_t* cairoCtx)
    {
        return size(chitraCtx, cairoCtx, txt.content(chitraCtx), w_, h_);
    }

    Size size(Context chitraCtx, cairo_t* cairoCtx, string value, double w = 0.0, double h = 0.0)
    {
        cairo_save(cairoCtx);
        // Do not use fill color since the text color will be added
        cairo_set_antialias(cairoCtx, CAIRO_ANTIALIAS_BEST);
        cairo_move_to(cairoCtx, x_, y_);
        auto layout = pango_cairo_create_layout(cairoCtx);
        if (w > 0)
            pango_layout_set_width(layout, cast(int)(w * PANGO_SCALE));

        if (h > 0)
            pango_layout_set_height(layout, cast(int)(h * PANGO_SCALE));

        pango_layout_set_markup(layout, value.toStringz, -1);
        pango_cairo_update_layout(cairoCtx, layout);
        pango_cairo_show_layout(cairoCtx, layout);
        pango_cairo_layout_path(cairoCtx, layout);

        if (shapeProps.strokeWidth > 0 && !shapeProps.noStroke)
            drawShapeProperties(chitraCtx, cairoCtx, shapeProps);
        else
            cairo_new_path(cairoCtx);

        int w1, h1;
        pango_layout_get_size(layout, &w1, &h1);

        cairo_restore(cairoCtx);
        g_object_unref(layout);

        return Size((cast(double)w1) / PANGO_SCALE, (cast(double)h1) / PANGO_SCALE);
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

    Size textSize(string txt, double w = 0.0, double h = 0.0)
    {
        auto formatted = FormattedString(txt);
        return textSize(formatted, w, h);
    }

    Size textSize(FormattedString txt, double w = 0.0, double h = 0.0)
    {
        auto props = updateProperties([defaultTextProperties, this.textProps, txt.currentProperties]);
        txt.currentProperties = props;
        auto s = Text(txt, 0, 0, w, h);
        // Copy only top level props
        s.textProps = props;
        s.shapeProps = this.shapeProps;
        return s.size(this, this.defaultCairoCtx);
    }

    string overflowText()
    {
        return this.overflowMarkup_;
    }
}
