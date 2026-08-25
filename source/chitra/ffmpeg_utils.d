module chitra.ffmpeg_utils;

import std.process : execute;
import std.exception : enforce;
import std.format : format;
import std.array : array;
import std.range : iota;
import std.file : write, tempDir, remove, exists;
import std.path : buildPath, absolutePath, extension;
import std.algorithm.searching : canFind;

import chitra.helpers;

string prepareFfmpegInputs(Frame[] frames)
{
    enforce(frames.length > 0, "Need at least one Frame to create animation");
    foreach (frame; frames)
        enforce(frame.path.exists, "PNG not found: " ~ frame.path);

    // ffmpeg's image2 demuxer wants an ordered list of inputs; the simplest
    // robust way to feed an arbitrary (non-sequentially-named) file list is
    // the concat demuxer, via a small text manifest.

    immutable listPath = "frames.txt";
    string manifest;
    foreach (frame; frames)
    {
        // ffmpeg's concat demuxer resolves relative paths against the
        // *list file's* directory, not the working directory — so every
        // entry is made absolute here to avoid "file not found" errors.
        manifest ~= format("file '%s'\n", frame.path.absolutePath);
        if (frame.durationSeconds > 0)
            manifest ~= format("duration %.2f\n", frame.durationSeconds);
    }

    // Add the last frame again if duration is set for the last frame
    // otherwise ffmpeg will skip the last frame
    if (frames[$ - 1].durationSeconds > 0)
        manifest ~= format("file '%s'\n", frames[$ - 1].path.absolutePath);

    write(listPath, manifest);

    return listPath;
}

void animateUsingFfmpeg(Frame[] frames, string outputPath, int fps = 10)
{
    auto listPath = prepareFfmpegInputs(frames);
    scope (exit) remove(listPath);

    string[] command = [
        "ffmpeg", "-y",
        "-f", "concat", "-safe", "0", "-i", listPath
    ];

    string[] codecArgs;
    string[] pixFmtArgs;
    string[] filterComplexArgs;
    string[] loopArgs;

    if (outputPath.extension == ".webm")
    {
        codecArgs = ["-c:v", "libvpx-vp9"];
        pixFmtArgs = ["-pix_fmt", "yuva420p"];
    }
    else if (outputPath.extension == ".gif")
    {
        filterComplexArgs = [
            "-filter_complex",
            // [0:v] split [a][b]                        => Split the video stream into
            //                                              two identical streams [a] and [b]
            // [a] palettegen=stats_mode=diff [p]        => Generate pallete from the first
            //                                              stream and name it as [p]
            // [b][p] paletteuse=dither=floyd_steinberg" => Use the previously generated pallete [p]
            "[0:v] split [a][b];[a] palettegen=stats_mode=diff [p];[b][p] paletteuse=dither=floyd_steinberg"
        ];
        // TODO: Add option to control loop (0 for Loop, -1 for no loop)
        loopArgs = ["-loop", "0"];
    }
    else if ([".mov", ".mp4"].canFind(outputPath.extension))
    {
        codecArgs = ["-c:v", "libx264"];
        pixFmtArgs = ["-pix_fmt", "yuv420p"];
    }

    command ~= codecArgs;
    command ~= pixFmtArgs;
    command ~= filterComplexArgs;
    command ~= loopArgs;
    command ~= outputPath;

    auto result = execute(command);

    enforce(result.status == 0, format("ffmpeg failed (exit %s):\n %s", result.status, result.output));
}
