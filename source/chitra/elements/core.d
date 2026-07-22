module chitra.elements.core;

public import chitra.pangocairo;
import chitra.context;
import chitra.properties;

void drawShapeProperties(Context chitraCtx, cairo_t* cairoCtx, ShapeProperties shapeProps)
{
    if (shapeProps.noFill)
        cairo_set_source_rgba(cairoCtx, 0, 0, 0, 0);
    else
        cairo_set_source_rgba(cairoCtx, shapeProps.fill.r,
                              shapeProps.fill.g, shapeProps.fill.b, shapeProps.fill.a);

    if (shapeProps.strokeWidth > 0 && !shapeProps.noStroke)
    {
        cairo_fill_preserve(cairoCtx);
        auto sw = chitraCtx.correctedSize(shapeProps.strokeWidth);
        cairo_set_line_width(cairoCtx, sw);

        if (shapeProps.strokeDash.length > 0)
            cairo_set_dash(cairoCtx, shapeProps.strokeDash.ptr, shapeProps.strokeDash.sizeof, shapeProps.strokeDashOffset);
        else
            cairo_set_dash(cairoCtx, null, 0, 0);

        cairo_set_line_cap(cairoCtx, shapeProps.strokeCap);
        cairo_set_line_join(cairoCtx, shapeProps.strokeJoin);
        cairo_set_source_rgba(cairoCtx, shapeProps.stroke.r,
                              shapeProps.stroke.g, shapeProps.stroke.b, shapeProps.stroke.a);
        cairo_stroke(cairoCtx);
    }
    else
        cairo_fill(cairoCtx);
}
