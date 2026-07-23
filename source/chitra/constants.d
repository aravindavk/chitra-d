module chitra.constants;

import std.math.constants;

import chitra.pangocairo;

// Math constants

enum TWO_PI = 2.0 * PI;
alias HALF_PI = PI_2;
alias QUARTER_PI = PI_4;

enum OPEN = "open";
enum PIE = "pie";
enum CHORD = "chord";

enum DEGREES = "degrees";
enum RADIANS = "radians";

enum BUTT = CAIRO_LINE_CAP_BUTT;
enum ROUND = CAIRO_LINE_CAP_ROUND;
enum SQUARE = CAIRO_LINE_CAP_SQUARE;

auto strokeCaps()
{
    return [
        "BUTT": BUTT,
        "ROUND": ROUND,
        "SQUARE": SQUARE
    ];
}

enum MITER = CAIRO_LINE_JOIN_MITER;
enum BEVEL = CAIRO_LINE_JOIN_BEVEL;
enum ROUND_ = CAIRO_LINE_JOIN_ROUND;

auto strokeJoins()
{
    return [
        "MITER": MITER,
        "BEVEL": BEVEL,
        "ROUND": ROUND_
    ];
}

enum CENTER = "center";
enum RADIUS = "radius";
enum CORNER = "corner";
enum CORNERS = "corners";

auto ovalModes()
{
    return [
        "CENTER": CENTER,
        "RADIUS": RADIUS,
        "CORNER": CORNER,
        "CORNERS": CORNERS
        ];
}

// Image or Background Fitting
enum FILL = "fill";
enum CONTAIN = "contain";
enum COVER = "cover";
enum CROP = "crop";

auto imageFittings()
{
    return [
        "FILL": FILL,
        "CONTAIN": CONTAIN,
        "COVER": COVER,
        "CROP": CROP
        ];
}

// Where the second object is drawn, the first is completely removed.
// Anywhere else it is left intact. The second object itself is not drawn.

// The effect of the CLEAR operator depends on the interpretation
// of the source. In cairo, this operator is bounded.

// | Resulting alpha (aR)   | Resulting color (xR) |
// | 0                      | 0                    |
enum CLEAR = CAIRO_OPERATOR_CLEAR;

//  The second object is drawn as if nothing else were below
//  . Only outside of the blue rectangle the red one is left intact.

// The effect of the SOURCE operator depends on the interpretation
// of the source. In cairo, this operator is bounded.
// |Resulting alpha (aR)    | Resulting color (xR) |
// |aA                      | xA                   |
enum SOURCE = CAIRO_OPERATOR_SOURCE;

// The image shows what you would expect if you held two
// semi-transparent slides on top of each other. This
// operator is cairo's default operator.

// The output of the OVER operator is the same for
// both bounded and unbounded source.
// | Resulting alpha (aR)     | Resulting color (xR)  |
// | aA + aB·(1−aA)           | (xaA + xaB·(1−aA))/aR |
enum OVER = CAIRO_OPERATOR_OVER;

// The first object is removed completely, the
// second is only drawn where the first was.

// Note that the transparency of the first object is taken
// into account. That is, the small blue rectangle is slightly
// lighter than it would have been, had the first object been opaque.

// The effect of the IN operator depends on the interpretation
// of the source. In cairo, this operator is unbounded.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | aA·aB    xA              |                      |
enum IN = CAIRO_OPERATOR_IN;

// The blue rectangle is drawn only where the red one wasn't.
// Since the red one was partially transparent, you can see a blue
// shadow in the overlapping area. Otherwise, the red
// object is completely removed.

// The effect of the OUT operator depends on the interpretation of
// the source. In cairo, this operator is unbounded.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | aA·(1−aB)                | xA                   |
enum OUT = CAIRO_OPERATOR_OUT;

// This leaves the first object mostly intact, but mixes both objects
// in the overlapping area. The second object object is not drawn except there.

// If you look closely, you will notice that the resulting color in the
// overlapping area is different from what the OVER operator produces.
// Any two operators produce different output in the overlapping area!

// The output of the ATOP operator is the same for both
// bounded and unbounded source.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | aB                       | xaA + xB·(1−aA)      |
enum ATOP = CAIRO_OPERATOR_ATOP;

// Leaves the first object untouched, the second is discarded completely.

// The output of the DEST operator is the same for
// both bounded and unbounded source.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | aB                       | xB                   |
enum DEST = CAIRO_OPERATOR_DEST;

// The result is similar to the OVER operator. Except that the
// "order" of the objects is reversed, so the second is drawn below the first.

// The output of the DEST_OVER operator is the same for
// both bounded and unbounded source.
// | Resulting alpha (aR)     | Resulting color (xR)  |
// | (1−aB)·aA + aB           | (xaA·(1−aB) + xaB)/aR |
enum DEST_OVER = CAIRO_OPERATOR_DEST_OVER;

// The blue rectangle is used to determine which part of the red
// one is left intact. Anything outside the overlapping area is removed.

// This works like the IN operator, but again with the second
// object "below" the first.

// Similar to the two interpretations of the source, it is possible
// to imagine the same distinction with regard to the destination.
// In cairo, the DEST_IN operator is unbounded.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | aA·aB                    | xB                   |
enum DEST_IN = CAIRO_OPERATOR_DEST_IN;

// The second object is used to reduce the visibility of the first
// in the overlapping area. Its transparency/opacity is taken into
// account. The second object is not drawn itself.

// The output of the DEST_OUT operator is the same for both
// bounded and unbounded interpretations.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | (1−aA)·aB                | xB                   |
enum DEST_OUT = CAIRO_OPERATOR_DEST_OUT;

// Same as the ATOP operator, but again as if the order of
// the drawing operations had been reversed.

// In cairo, the DEST_ATOP operator is unbounded.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | aA                       | xA·(1−aB) + xaB      |
enum DEST_ATOP = CAIRO_OPERATOR_DEST_ATOP;

// The output of the XOR operator is the same for both
// bounded and unbounded source interpretations.
// | Resulting alpha (aR)     | Resulting color (xR)          |
// | aA + aB − 2·aA·aB        | (xaA·(1−aB) + xaB·(1−aA))/aR  |
enum XOR = CAIRO_OPERATOR_XOR;

// The output of the ADD operator is the same for both
// bounded and unbounded source interpretations.
// | Resulting alpha (aR)     | Resulting color (xR) |
// | min(1, aA+aB)            | (xaA + xaB)/aR       |
enum ADD = CAIRO_OPERATOR_ADD;

// The output of the SATURATE operator is the same for
// both bounded and unbounded source interpretations.
// | Resulting alpha (aR)     | Resulting color (xR)          |
// | min(1, aA+aB)            | (min(aA, 1−aB)·xA + xaB)/aR   |
enum SATURATE = CAIRO_OPERATOR_SATURATE;

// Blend mode function:
// f(xA,xB) = xA·xB

// The result color is at least as dark as the darker of the two input colors.
enum MULTIPLY = CAIRO_OPERATOR_MULTIPLY;

// Blend mode function:
// f(xA,xB) = xA + xB − xA·xB

// Input colors are complemented and multiplied, the product is
// complemented again. The result is at least as light as the
// lighter of the input colors.
enum SCREEN = CAIRO_OPERATOR_SCREEN;

// Blend mode function:
// if (xB ≤ 0.5)
//     f(xA,xB) = 2·xA·xB
// else
//     f(xA,xB) = 1 − 2·(1 − xA)·(1 − xB)

// Multiplies or screens colors, depending on the
// lightness of the destination color.
enum OVERLAY = CAIRO_OPERATOR_OVERLAY;

// Blend mode function:
// f(xA,xB) = min(xA,xB)

// Selects the darker of the color values in each component.
enum DARKEN = CAIRO_OPERATOR_DARKEN;

// Blend mode function:
// f(xA,xB) = max(xA,xB)

// Selects the lighter of the color values in each component.
enum LIGHTEN = CAIRO_OPERATOR_LIGHTEN;

// Blend mode function:
// if (xA < 1)
//     f(xA,xB) = min(1, xB/(1−xA))
// else
//     f(xA,xB) = 1

// Brightens the destination color by a factor depending on the source color.
enum COLOR_DODGE = CAIRO_OPERATOR_COLOR_DODGE;

// Blend mode function:
// if (xA > 0)
//     f(xA,xB) = 1 − min(1, (1−xB)/xA)
// else
//     f(xA,xB) = 0

// Darkens the destination color by a factor depending on the source color.
enum COLOR_BURN = CAIRO_OPERATOR_COLOR_BURN;

// Blend mode function:
// if (xA ≤ 0.5)
//     f(xA,xB) = 2·xA·xB
// else
//     f(xA,xB) = 1 − 2·(1 − xA)·(1 − xB)

// Multiplies or screens colors, depending on the lightness of the source color.
enum HARD_LIGHT = CAIRO_OPERATOR_HARD_LIGHT;

// Blend mode function:
// if (xA ≤ 0.5)
//     f(xA,xB) = xB − (1 − 2·xA)·xB·(1 − xB)
// else
//     f(xA,xB) = xB + (2·xA − 1)·(g(xB) − xB)

// where
// if (x ≤ 0.25)
//     g(x) = ((16·x − 12)·x + 4)·x
// else
//     g(x) = sqrt(x)

// Darkens or lightens, depending on the source color.
enum SOFT_LIGHT = CAIRO_OPERATOR_SOFT_LIGHT;

// Blend mode function:
// f(xA,xB) = abs(xB−xA)

// Takes the difference of the destination and source colors.
enum DIFFERENCE = CAIRO_OPERATOR_DIFFERENCE;

// Blend mode function:
// f(xA,xB) = xA + xB − 2·xA·xB

// The effect is similar to DIFFERENCE, but has lower contrast.
enum EXCLUSION = CAIRO_OPERATOR_EXCLUSION;

// Blend mode function:
// f(cA,cB) = set_lum(set_sat(cA, sat(cB)), lum(cB))

// Creates a color with the hue of the source and the
// saturation and luminosity of the destination.
enum HSL_HUE = CAIRO_OPERATOR_HSL_HUE;

// Blend mode function:
// f(cA,cB) = set_lum(set_sat(cB, sat(cA)), lum(cB))

// Creates a color with the saturation of the source
// and the hue and luminosity of the destination. Painting
// with this mode onto a gray area produces no change.
enum HSL_SATURATION = CAIRO_OPERATOR_HSL_SATURATION;

// Blend mode function:
// f(cA,cB) = set_lum(cA, lum(cB))

// Creates a color with the hue and saturation of the source and
// the luminosity of the destination. This preserves the gray levels
// of the destination and is useful for coloring monochrome
// images or tinting color images.
enum HSL_COLOR = CAIRO_OPERATOR_HSL_COLOR;

// Blend mode function:
// f(cA,cB) = set_lum(cB, lum(cA))

// Creates a color with the luminosity of the source and
// the hue and saturation of the destination. This produces
// an inverse effect to CAIRO_OPERATOR_HSL_COLOR.
enum HSL_LUMINOSITY = CAIRO_OPERATOR_HSL_LUMINOSITY;

auto blendModes()
{
    return [
        "CLEAR": CLEAR,
        "SOURCE": SOURCE,
        "OVER": OVER,
        "IN": IN,
        "OUT": OUT,
        "ATOP": ATOP,
        "DEST": DEST,
        "DEST_OVER": DEST_OVER,
        "DEST_IN": DEST_IN,
        "DEST_OUT": DEST_OUT,
        "DEST_ATOP": DEST_ATOP,
        "XOR": XOR,
        "ADD": ADD,
        "SATURATE": SATURATE,
        "MULTIPLY": MULTIPLY,
        "SCREEN": SCREEN,
        "OVERLAY": OVERLAY,
        "DARKEN": DARKEN,
        "LIGHTEN": LIGHTEN,
        "COLOR_DODGE": COLOR_DODGE,
        "COLOR_BURN": COLOR_BURN,
        "HARD_LIGHT": HARD_LIGHT,
        "SOFT_LIGHT": SOFT_LIGHT,
        "DIFFERENCE": DIFFERENCE,
        "EXCLUSION": EXCLUSION,
        "HSL_HUE": HSL_HUE,
        "HSL_SATURATION": HSL_SATURATION,
        "HSL_COLOR": HSL_COLOR,
        "HSL_LUMINOSITY": HSL_LUMINOSITY
    ];
}
