module chitra.elements.end_frame;

import std.conv : to;

import chitra.context;
import chitra.elements.core;

struct EndFrame
{
    double frameDuration = 0;
    bool clear = false;

    void draw(Context chitraCtx, cairo_t* cairoCtx)
    {
    }
}

mixin template endFrameFunctions()
{
    /**
       Ends the current frame.

       ---
       ctx.endFrame;
       ---
     */
    void endFrame(bool clear = false)
    {
        EndFrame s;
        s.frameDuration = this.frameDuration_;
        s.clear = clear;
        s.draw(this, this.defaultCairoCtx);
        this.elements ~= Element(s);
        setPageVariable("currentFrame", this.pageVars["currentFrame"].to!int + 1);
        setDocumentVariable("totalFrames", this.documentVars["totalFrames"].to!int + 1);
    }

    double frameDuration_ = 1.0 / 10.0;

    void frameDuration(double value)
    {
        this.frameDuration_ = value;
    }

    void frameRate(int fps)
    {
        this.frameDuration_ = 1.0 / fps;
    }
}
