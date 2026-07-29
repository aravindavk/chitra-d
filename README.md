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
<a href="https://github.com/aravindavk/chitra-d/wiki">Read the Docs</a>

## Thanks

- [Cairo Graphics](https://www.cairographics.org/)
- Drawing API syntax are inspired from [Drawbot](https://drawbot.com/) and [Processing](https://processing.org/).

## Contributing

- Fork it (https://github.com/aravindavk/chitra-d/fork)
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request

## Contributors

- [Aravinda VK](https://github.com/aravindavk) - Creator and Maintainer
