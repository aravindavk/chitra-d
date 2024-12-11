module chitra.elements.core;

public import chitra.pangocairo;
import chitra.context;
import chitra.properties;

void drawShapeProperties(Context chitraCtx, cairo_t* cairoCtx, ShapeProperties shapeProps)
{
    if (shapeProps.noFill)
        cairo_set_source_rgba(cairoCtx, 0, 0, 0, 0);
    else
        cairo_set_source_rgba(cairoCtx, shapeProps.fill.toRGBAf.r,
                              shapeProps.fill.toRGBAf.g, shapeProps.fill.toRGBAf.b, shapeProps.fill.toRGBAf.a);

    if (shapeProps.strokeWidth > 0 && !shapeProps.noStroke)
    {
        cairo_fill_preserve(cairoCtx);
        auto sw = chitraCtx.correctedSize(shapeProps.strokeWidth);
        cairo_set_line_width(cairoCtx, sw);
        // if @line_dash.enabled?
        //   LibCairo.cairo_set_dash(cairo_ctx, @line_dash.values.to_unsafe, @line_dash.values.size, @line_dash.offset)
        // else
        //   LibCairo.cairo_set_dash(cairo_ctx, [] of Float64, 0, 0)
        // end
        // LibCairo.cairo_set_line_cap(cairo_ctx, @line_cap)
        // LibCairo.cairo_set_line_join(cairo_ctx, @line_join)
        cairo_set_source_rgba(cairoCtx, shapeProps.stroke.toRGBAf.r,
                              shapeProps.stroke.toRGBAf.g, shapeProps.stroke.toRGBAf.b, shapeProps.stroke.toRGBAf.a);
        cairo_stroke(cairoCtx);
    }
    else
        cairo_fill(cairoCtx);
}
