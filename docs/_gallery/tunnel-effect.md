---
title: Tunnel Effect
image: /static/images/tunnel-effect.png
---

Port of Tunnel Effect example from [PlotDevice](https://plotdevice.io/).

![Tunnel Effect](/static/images/tunnel-effect.png)

## Source

```d
#!/usr/bin/env dub
/+ dub.sdl:
dependency "chitra" version="~>~main"
+/


import std.random;
import std.math;

import chitra;

void main()
{
    // Create a Square context with size as 1080
    auto ctx = new Chitra(1280, 960);

    with (ctx)
    {
        background("#eeeeee");
        auto startX = 100;
        auto startY = 100;
        //stroke(0.2);
        double c = uniform(0.0, 1.0);
        
        foreach(i; 0..300)
        {
            auto delta = (uniform(0.0, 1.0) - 0.5) * 0.1;
            auto x = width / 2 + sin(c + delta) * (i + uniform(-10, 10));
            auto y = height / 2 + cos(c + delta) * (i + uniform(-10, 10));
            auto s = uniform(0.0, c*2);

            fill(76, 51, uniform(0, 255), uniform(0.0, 1.0));

            auto primitive = choice([0, 1]);
            if (primitive == 0)
                oval(x - s / 2, y - s / 2, s, s);
            else
                rect(x - s / 2, y - s / 2, s, s);

            c += uniform(0.0, 1.0) * 0.25;
        }

        // Save as png image
        saveAs("tunnel-effect.png");
    }
}
```
