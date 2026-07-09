module chitra.elements.markup_tokens;

import std.array;
import std.string;
import std.math;

struct Tag
{
    string name;
    string data;

    // Utility that provides formatted Tag
    //       <NAME ATTRIBUTES..>
    // Like: <span color="blue">
    string startTag()
    {
        return "<" ~ name ~ " " ~ data ~ ">";
    }

    // Closing tag
    //         NAME
    // Like: </span>
    string endTag()
    {
        return "</" ~ name ~ ">";
    }
}

/**
   Finds the Open tags for the given markup text.

   For example, in the following example, last span
   tag closing is not given. But <b> tag was opened
   and closed. So this should return only <span> tag.
   ---
   <span color="blue">Hello <b>World!</b> Again
   ---
 */
Tag[] findOpenTags(string markup)
{
    int markupIndex = 0;
    long markupLength = cast(int) markup.length;
    string plainText;
    Tag[] tags;

    while (markupIndex < markupLength)
    {
        char c = markup[markupIndex];

        if (c == '<')
        {
            string tag;
            // Collect the tag name and attributes.
            while (markupIndex < cast(int) markup.length && markup[markupIndex] != '>')
            {
                if (markup[markupIndex] != '<')
                    tag ~= markup[markupIndex];

                markupIndex++;
            }

            // Everything between < and >. Split to extract the tag
            // name and attributes if any.
            auto parts = tag.split(" ");
            if (parts.length > 0)
                tags ~= Tag(parts[0], parts[1..$].join(" "));

            if (markupIndex < cast(int) markup.length)
                markupIndex++;   // skip '>'
        }
        else
            markupIndex++;
    }

    Tag[] outtags;
    // Collected tags above will have closing tags
    // as well that starts with </
    // Remove the last open tag from the list whenever
    // a closing tag is found.

    foreach(tag; tags)
    {
        if (tag.name[0] != '/')
            outtags ~= tag;
        else
            outtags.popBack;
    }

    return outtags;
}

/**
   Removes markup chars and returns only plain text.

   ---
   <span color="blue">Hello <b>World!</b></span>
   ---

   above will return

   ---
   Hello World!
   ---
 */
string markupToPlainText(string markup)
{
    int markupIndex = 0;
    long markupLength = cast(int) markup.length;
    string plainText;

    while (markupIndex < markupLength)
    {
        char c = markup[markupIndex];

        if (c == '<')
        {
            // Skip the whole tag.
            while (markupIndex < cast(int) markup.length && markup[markupIndex] != '>')
                markupIndex++;

            if (markupIndex < cast(int) markup.length)
                markupIndex++;   // skip '>'
        }
        else
        {
            markupIndex++;
            plainText ~= c;
        }
    }

    return plainText;
}


/**
   Returns the index of markup text based on the index in the plain text.

   Stop finding once it gets the result.

   Mapping example:

   ---
                                                  0  1  2  3  4  5
                                                  H  e  l  l  o
   0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 21 23 24 25
   < s p a n   c o l o r  =  "  b  l  u  e  "  >  H  e  l  l  o     <

         6  7  8  9  10 11
         W  o  r  l  d  !
   26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
   b  >  W  o  r  l  d  !  <  /  b  >  <  /  s  p  a  n  >
   ---
 */
int plainTextIndexToMarkupIndex(string markup, long plainIndex)
{
    int plainCount  = 0;
    int markupIndex = 0;
    long markupLength = cast(int) markup.length;

    while (markupIndex < markupLength && plainCount < plainIndex)
    {
        char c = markup[markupIndex];

        if (c == '<')
        {
            // Skip the whole tag.
            while (markupIndex < cast(int) markup.length && markup[markupIndex] != '>')
                markupIndex++;

            if (markupIndex < cast(int) markup.length)
                markupIndex++;   // skip '>'
        }
        else
        {
            markupIndex++;
            plainCount++;
        }
    }

    return markupIndex;
}

struct Token
{
    string part;
    string rest;
}

/**
   Splits the Markup into words based on the equivalant plain text words.

   Similar to binary search, it gives the text
   to check if it fits the box or not.
 */
struct MarkupToken
{
    string markup;
    string[] words;
    long index;
    string plainText;
    int[] plainWordEndIndices;
    int[] markupWordEndIndices;
    int mark;
    int markHigh;
    int markLow;
    int wordsCount;

    this(string markup)
    {
        this.markup = markup;
        this.plainText = markupToPlainText(markup);
        this.words = plainText.split(" ");
        auto wordEnd = 0;
        wordsCount = cast(int)words.length;
        markHigh = wordsCount - 1;
        mark = markHigh;
        foreach(idx; 0 .. wordsCount)
        {
            wordEnd = cast(int)words[0 .. idx + 1].join(" ").length;
            plainWordEndIndices ~= wordEnd;
            markupWordEndIndices ~= plainTextIndexToMarkupIndex(markup, wordEnd);
        }
    }

    /**
       For a given index, fetch the markup text after this index
       and add open tags as prefix. All the closing tags will be
       with the markup text itself.
     */
    string markupTextFromIndex(long markupIndex)
    {
        auto tags = findOpenTags(markup[0 .. markupIndex + 1]);
        string outdata;
        foreach(tag; tags)
            outdata ~= tag.startTag;

        outdata ~= markup[markupIndex .. $].stripLeft(" ");

        return outdata;
    }

    /**
       For a given index, fetch the markup text till this point and
       Add all the close tags for the Open tags found
       in the markup slice.
     */
    string markupTextTillIndex(long markupIndex)
    {
        if (markupIndex == -1) return "";

        auto tags = findOpenTags(markup[0 .. markupIndex+1]);
        string outdata;
        outdata ~= markup[0 .. markupIndex];

        foreach_reverse(tag; tags)
            outdata ~= tag.endTag;

        return outdata;
    }

    int findMidMark()
    {
        return cast(int)(markLow + (markHigh - markLow) / 2);
    }

    /**
       When the text doesn't fit the box then it is marked as too high to fit.
     */
    void notOkHigh()
    {
        markHigh = mark - 1;
        mark = findMidMark;
    }

    /**
       When the text doesn't fit the box then it is marked as too low to fit.
     */
    void notOkLow()
    {
        markLow = mark + 1;
        mark = findMidMark;
    }

    /**
       Get the previous part and rest (with reference to the Mark)
    */
    Token getPrev()
    {
        if (mark - 1 <= 0)
            return Token("", "");

        return getByWordIndex(mark - 1);
    }

    /**
       Get the current part and rest (with reference to the Mark)
    */
    Token get()
    {
        return getByWordIndex(mark);
    }

    /**
       Get the next part and rest (with reference to the Mark)
    */
    Token getNext()
    {
        if (mark + 1 >= wordsCount)
            return Token("", "");

        return getByWordIndex(mark + 1);
    }

    Token getByWordIndex(int wordIdx)
    {
        auto idx = markupWordEndIndices[wordIdx];

        return Token(
            markupTextTillIndex(idx),
            markupTextFromIndex(idx)
        );
    }
}
