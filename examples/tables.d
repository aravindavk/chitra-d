#!/usr/bin/env dub
/+ dub.sdl:
 dependency "chitra" path="../"
+/
import std.stdio;
import std.format;
import std.array : replicate, replace, array;
import std.range : chunks;
import std.algorithm : map;
import std.conv;
import std.math.trigonometry : sin;
import std.math : isNaN;

import chitra;

void main()
{
    auto ctx = new Chitra(1024);

    with (ctx)
    {
        background(255);
        noStroke;
        font("IBM Plex Mono", 10);
        newTable("t1", 50, 50, cols: 3, paddingX: 5);
        //tableSize("t1", 50, 50, width - 100, height - 100);
        tableColumnAlign("t1", 2, RIGHT);
        tableColumnAlign("t1", 3, RIGHT);

        newTextStyle("firstCol")
            .font("American Typewriter")
            .color("blue");

        newTextStyle("tblHeader")
            .font("American Typewriter")
            .color("black");

        tableColumnStyle("t1", 1, "firstCol");
        tableHeaderStyle("t1", "tblHeader");
        // tableAddHeader("t1", "Name", "Color", "Hex");
        // foreach(nc; namedColors)
        //     tableAddRow("t1", nc.name, "<span bgcolor=\"" ~ nc.col.hexString ~ "\">    </span>", nc.col.hexString);

        tableColumnWidths("t1", 200, 80, 80);

        tableAddHeader("t1", "Project", "Version", "Commits");
        tableAddRow("t1", "Chitra", 0.5, 125);
        tableAddRow("t1", "Dataframes", 0.1, 27);
        tableAddRow("t1", "This is very long text, how this will work?", 0.5, 28);
        tableAddRow("t1", "Binnacle", 1.1, 31);

        drawTable("t1");

        font("EB Garamond");
        fontSize(10);
        newTable("t2", 50, 300, cols: 5, paddingY: 1);
        // tableSize("t2", 50, 300, width - 100, height - 200 - 100);
        tableColumnWidths("t2", 50, 400, 100, 100, 100);
        tableAddHeader("t2", "Sl No", "Description", "Quantity", "Unit Price (INR)", "Amount (INR)");
        tableAddRow("t2", 1, "Project 1", 1, 20000.0, 20000.0);
        tableAddRow("t2", 2, "Project 2", 2, 50000.0, 100000.0);
        tableAddRow("t2", "", "Total", "", "", 120000.0);

        tableHeaderStyle("t2", "tblHeader");
        
        tableColumnAlign("t2", RIGHT);
        tableColumnAlign("t2", 2, LEFT);


        saveState;
        stroke("#aaaaaa");
        noFill;
        foreach(i; 0 .. tableColumnsCount("t2"))
        {
            foreach(j; 0 .. tableRowsCount("t2"))
            {
                rect(tableCell("t2", i + 1, j + 1));
            }
        }

        fill("gold");
        rect(tableCell("t2", 5, 4));
        restoreState;

        drawTable("t2");

        font("EB Garamond");
        newTable("t3", 50, 700, cols: 3)
            .setMaxWidth(500)
            .addHeader("NAME", "VALUE", "")
            .addRow("ABCD", 25, "")
            .addRow("EFGH", 75, "")
            .addRow("IJKL", 80, "")
            .addRow("MNOP", 100, "")
            .addRow("QRSTUVWXYZ", 5, "")
            .columnAlign(2, RIGHT);

        saveState;
        auto values = [25, 75, 40, 100, 5];

        void cellWidthAndColor(int idx, Box cell)
        {
            auto val = values[idx];
            if (val > 50)
                fill("green", 0.5);
            else if (val > 30)
                fill("orange", 0.5);
            else
                fill("red", 0.5);

            cell.width = cell.width * val / 100;
            rect(cell.inset(dy: 2));
        }

        auto tbl = table("t3");
        foreach(i; 2 .. 7)
        {
            cellWidthAndColor(i - 2, tbl.cell(3, i));
        }
        restoreState;

        tbl.draw;

        saveAs("output/tables.png");
    }
}
