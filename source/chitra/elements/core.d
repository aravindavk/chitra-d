module chitra.elements.core;

public import chitra.pangocairo;
import chitra.properties;

void drawShapeProperties(cairo_t* cairoCtx, ShapeProperties shapeProps)
{
    if (shapeProps.noFill)
        cairo_set_source_rgba(cairoCtx, 0, 0, 0, 0);
    else
        cairo_set_source_rgba(cairoCtx, shapeProps.fill.r100,
                              shapeProps.fill.g100, shapeProps.fill.b100, shapeProps.fill.a100);

    if (shapeProps.strokeWidth > 0)
    {
        cairo_fill_preserve(cairoCtx);
        cairo_set_line_width(cairoCtx, shapeProps.strokeWidth);
        // if @line_dash.enabled?
        //   LibCairo.cairo_set_dash(cairo_ctx, @line_dash.values.to_unsafe, @line_dash.values.size, @line_dash.offset)
        // else
        //   LibCairo.cairo_set_dash(cairo_ctx, [] of Float64, 0, 0)
        // end
        // LibCairo.cairo_set_line_cap(cairo_ctx, @line_cap)
        // LibCairo.cairo_set_line_join(cairo_ctx, @line_join)
        cairo_set_source_rgba(cairoCtx, shapeProps.stroke.r100,
                              shapeProps.stroke.g100, shapeProps.stroke.b100, shapeProps.stroke.a100);
        cairo_stroke(cairoCtx);
    }
    else
        cairo_fill(cairoCtx);
}
