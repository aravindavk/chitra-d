/+ dub.sdl:
 dependency "chitra" path="../"
 +/

import std.stdio;
import std.datetime.systime : Clock, SysTime;
import std.format : format;

import chitra;

string dateTimeNow()
{
    SysTime now = Clock.currTime();

    // 2. Format as YYYY-MM-DD HH:MM:SS
    return format("%04d-%02d-%02d %02d:%02d:%02d",
                  now.year, cast(int)now.month, now.day,
                  now.hour, now.minute, now.second);
}

void addFooter(Chitra ctx)
{
    with(ctx)
    {
        saveState;
        font("IBM Plex Mono", 12);
        textAlign(CENTER);
        text("{{ currentPage }} / {{ totalPages }}", 0, height - 50, width, 50);
        textAlign(RIGHT);
        font("American Typewriter", 10);
        text("{{ chapterName }}", 50, height - 50, width - 100, 50);
        restoreState;
    }
}

void main()
{
    auto ctx = new Chitra();

    with (ctx)
    {
        noStroke;
        font("Inter", 14);

        setVariable("date", dateTimeNow);

        setVariable("chapterName", "Chapter 1");
        rect(100, 100, 200);
        addFooter(ctx);

        newPage;
        rect(100, 100, 200);
        addFooter(ctx);

        newPage;
        setVariable("chapterName", "Chapter 2");
        addFooter(ctx);

        fill(100);
        text("Last updated on {{ date }}", 100, 500);

        saveAs("output/multipage.pdf");
    }
}
