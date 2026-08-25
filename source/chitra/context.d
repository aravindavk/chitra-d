module chitra.context;

import std.conv : to;
import std.string : toLower, split, toStringz;
import std.algorithm.mutation : swap;
import std.algorithm;
import std.format : format;

import chitra.pangocairo;
import chitra.surfaces;
import chitra.paper_sizes;
import chitra.rgba;
import chitra.ffmpeg_utils;

// Import all the elements
import chitra.elements;
import chitra.properties;
import chitra.helpers;
import chitra.elements.path;

const baseResolution = 72.0;
const defaultResolution = 72;
const defaultWidth = 700;
const portraitMode = "portrait";
const landscapeMode = "landscape";

struct SavedStateContext
{
    ShapeProperties shapeProps;
    TextProperties textProps;
    BorderProperties borderProps;
    float colorScaleMax;
    float colorScaleAlphaMax;
    bool group;
}

class Context
{
    Element[] elements;
    cairo_surface_t* defaultSurface;
    cairo_t* defaultCairoCtx;
    private double width_;
    private double height_;
    int resolution_ = 0;
    ShapeProperties shapeProps;
    TextProperties textProps;
    BorderProperties borderProps;
    float colorScaleMax = 255.0;
    float colorScaleAlphaMax = 1.0;
    Grid[string] grids_;
    string overflowMarkup_;
    SavedStateContext[] savedStateContexts;
    Path lastPath_;
    string[string] documentVars;
    string[string] pageVars;
    double frameDuration_ = 1.0 / 10.0;
    bool keepTemporaryFrames_ = false;

    @property double width() const
    {
        return width_;
    }

    @property double height() const
    {
        return height_;
    }

    // Change the size as per the resolution specified
    // When a different resolution is specified other
    // than the default one, then correct it accordingly.
    T correctedSize(T)(T value)
    {
        if (resolution_ == 0 || resolution_ == baseResolution)
            return value;

        return cast(T)((value / baseResolution) * resolution_);
    }

    T actualSize(T)(T value)
    {
        if (resolution_ == 0 || resolution_ == baseResolution)
            return value;

        return cast(T)((value / cast(double)resolution_) * baseResolution);
    }

    void setSize(double width = defaultWidth, double height = 0)
    {
        this.width_ = width;
        this.height_ = height == 0 ? width : height;
        this.defaultSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32,
            correctedSize(this.width_).to!int, correctedSize(this.height_).to!int);
        this.defaultCairoCtx = cairo_create(this.defaultSurface);

        // Scale the default stroke width based on the resolution
        shapeProps.strokeWidth = correctedSize(shapeProps.strokeWidth);

        // FIXME: fill and stroke colors are not initialized properly!
        // is this nested struct initialize issue or colors lib issue? Not sure.
        shapeProps.fill = RGBA(0, 0, 0);
        shapeProps.stroke = RGBA(0, 0, 0);

        // Initialize the default values
        setPageVariable("currentPage", 1);
        setDocumentVariable("totalPages", 1);

        setPageVariable("currentFrame", 1);

        // Animation Frame defaults (endFrame triggers
        // increment, so start from zero)
        setDocumentVariable("totalFrames", 0);
    }

    this(double width = defaultWidth, double height = 0)
    {
        setSize(width, height);
    }

    void setSize(string paper)
    {
        string orientation = portraitMode;
        auto parts = paper.toLower.split(",");
        if (parts.length == 2)
        {
            if (parts[0] == portraitMode || parts[0] == landscapeMode)
            {
                paper = parts[1];
                orientation = parts[0];
            }
            else if (parts[1] == portraitMode || parts[1] == landscapeMode)
            {
                paper = parts[0];
                orientation = parts[1];
            }
        }

        auto size = paper in paperSizes;
        if (size is null)
        {
            throw new Exception("invalid paper");
        }
        auto w = (*size)[0].mm;
        auto h = (*size)[1].mm;

        if (orientation == landscapeMode)
            swap(w, h);

        setSize(w, h);
    }

    this(string paper)
    {
        setSize(paper);
    }

    void size(double width = defaultWidth, double height = 0)
    {
        setSize(width, height);
    }

    void size(string paper)
    {
        setSize(paper);
    }

    bool isAnimationExt(string path)
    {
        import std.path : extension;

        return [".gif", ".webm", ".mp4", ".mov"].canFind(path.extension);
    }

    void saveAnimation(string outputFile, int resolution, bool loopAnimation)
    {
        cairo_t * cairoCtx;
        cairo_surface_t* surface;
        Frame[] frames;
        auto frameCount = 1;
        auto w = correctedSize(this.width_);
        auto h = correctedSize(this.height_);

        import std.file : mkdirRecurse, rmdirRecurse, exists;
        import std.sumtype : match, get;

        // Cleanup and create directory
        auto framesDir = ".frames";

        if (framesDir.exists)
            rmdirRecurse(framesDir);

        mkdirRecurse(framesDir);

        scope (exit)
        {
            if (!this.keepTemporaryFrames_)
                rmdirRecurse(framesDir);
        }

        foreach (idx, element; elements)
        {
            // Create the image surface only it is the
            // first one or a endFrame command is called with clear
            if (idx == 0 || surface is null)
            {
                surface = createPngSurface(outputFile, w, h);
                cairoCtx = cairo_create(surface);
            }

            // Create a frame PNG image under .frames
            // when endFrame command is called
            if (element.match!(value => typeof(value).stringof) == "EndFrame")
            {
                auto ele = element.get!EndFrame;
                Frame frame;
                frame.index = frameCount;
                frame.path = format(framesDir ~ "/frame-%05d.png", frameCount);
                frame.durationSeconds = ele.frameDuration;
                frames ~= frame;
                cairo_surface_write_to_png(surface, frame.path.toStringz);
                frameCount++;

                // If Clear is needed after a frame is ended.
                if (ele.clear)
                {
                    cairo_surface_finish(surface);
                    surface = null;
                    cairoCtx = null;
                }
            }
            else
                element.draw(this, cairoCtx);
        }

        // TODO: Get and pass the first frame duration
        animateUsingFfmpeg(
            frames,
            outputFile,
            loopAnimation: loopAnimation
        );
    }

    void saveAs(string outputFile, int resolution = defaultResolution, bool loopAnimation = true)
    {
        auto prevResolution = resolution_;
        if (resolution > 0)
            resolution_ = resolution;

        cairo_surface_t* surface;

        auto w = correctedSize(this.width_);
        auto h = correctedSize(this.height_);

        if (outputFile.endsWith(".pdf"))
            surface = createPdfSurface(outputFile, w, h);
        else if (outputFile.endsWith(".png"))
            surface = createPngSurface(outputFile, w, h);
        else if (outputFile.endsWith(".svg"))
            surface = createSvgSurface(outputFile, w, h);
        else if (isAnimationExt(outputFile))
            return saveAnimation(outputFile, resolution, loopAnimation);
        else
            return;

        auto cairoCtx = cairo_create(surface);

        foreach (element; elements)
            element.draw(this, cairoCtx);

        if (outputFile.endsWith(".png"))
            cairo_surface_write_to_png(surface, outputFile.toStringz);

        cairo_surface_finish(surface);
        // Reset the previous resolution to make sure it works the same
        // when multiple times saveAs is called.
        resolution_ = prevResolution;
    }

    // Reset the drawing to clean and empty canvas
    // ```
    // auto ctx = new Chitra;
    // ctx.fill(0);
    // ctx.rect(0, 0, width, height);
    // ctx.saveAs("slide1.png");
    // ctx.newDrawing;
    // ctx.fill(0, 0, 1);
    // ctx.rect(0, 0, width, height);
    // ctx.saveAs("slide2.png");
    // ```
    void newDrawing()
    {
        elements = [];
        defaultSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32,
                                                    correctedSize(this.width_).to!int, correctedSize(this.height_).to!int);
        defaultCairoCtx = cairo_create(this.defaultSurface);
        shapeProps = ShapeProperties.init;
        textProps = TextProperties.init;
    }

    void setPageVariable(T)(string key, T value)
    {
        this.pageVars[key] = value.to!string;
    }

    void setDocumentVariable(T)(string key, T value)
    {
        this.documentVars[key] = value.to!string;
    }

    void setVariable(T)(string key, T value)
    {
        setPageVariable(key, value);
    }
}
