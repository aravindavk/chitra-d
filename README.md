# Chitra - 2D graphics library - D programming language

<a href="https://chitra.aravindavk.in"><img src="static/chitra-logo.png" alt="CHITRA" width="300"/></a>

## Hello Rectangle

```d

import chitra;

void main()
{
    auto ctx = Chitra(700);
    with (ctx)
    {
        background(255);
        fill(0, 0, 255);
        rect(100, 100, 500, 200);
        saveAs("rect.png");
    }
}
```

## Sponsors

<a href="https://kadalu.tech"><img src="static/kadalu-technologies-logo.svg" alt="Kadalu Technologies" width="200"/></a>

<a href="https://fossunited.org"><img src="static/FOSS United Logo Black.png" alt="FOSS United" width="200"/></a>

## Documentation
Read the Docs https://github.com/aravindavk/chitra-d/wiki

## Blog Posts
* Generating 5mm dot pages using Chitra https://aravindavk.in/blog/5mm-dot-pages-using-chitra (Shared earlier in this forum; added here to keep the links together)
* Distance between two points https://aravindavk.in/blog/distance-between-two-points
* Tinted Images - Chitra https://aravindavk.in/blog/tinted-images
* Half-Tinted Magic: How to Add a Color Tint to Just Part of an Image https://aravindavk.in/blog/half-tinted-magic
* Perfect Fit Every Time: Automatically Resize Text https://aravindavk.in/blog/auto-resize-text-chitra
* Paper Elephant - Chitra https://aravindavk.in/blog/paper-elephant-chitra
* Highlight your Code with Chitra's New Syntax Highlighting Feature! https://aravindavk.in/blog/syntax-highlighting-chitra
