# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.2.0] - 2024-12-27
- Add support to draw border.
- Remove stroke from `point` and `pixel` drawing APIs.
- Allow override one corner radius while drawing a rectangle.
- Disallow setting `width` and `height` after initialization.
- Added FormattedString and text API
- Moved resolution settings to `saveAs` function.
- Change default measurements to `point(pt)`.
- Added support for `100.px`, `10.pt` while specifying the co-ordinates, size etc.
- Added support for rendering PNG images (`image(PATH, x, y)`).
- Added functions to get image dimentions, `imageWidth(PATH)`, `imageHeight(PATH)`
  and `imageSize(PATH)`. `imageSize` returns the `struct{double width, double height}`. 

## [v0.1.1] - 2024-12-04

- Fixed the issue with different resolution settings. Changed the base resolution to
  `72` and default resolution to `300`. All the measurements and co-ordinates to
  provided resolution.
- `noStroke` was ignored and the generated images contains the stroke. With this release,
  fixed the issue with `noStroke`.
- Added a few examples.

## [v0.1.0] - 2024-12-01

- Added support for `10.mm`, `1.cm`, `2.inch` while specifying the co-ordinates, size etc.
- Added support for canvas size and resolution configuration while creating the Chitra instance.
- Added support for basic shapes: `rect`, `point`, `square`, `oval`, `circle`, `pixel`, `line`, `polygon` etc.
- Added support for rounded rectangle.
- Added Fill and Stroke color configurations (RGBA, Hex, color names).
- `noFill` and `noStroke` added.
- Added documentation.
- Added support for background color.
- New page and new drawing APIs supported.
- Transformations added: `rotate`, `translate` and `scale`.
- Support added tp export to `pdf`, `svg` and `png` formats.
- Published the project to https://code.dlang.org/packages/chitra

[Unreleased]: https://github.com/aravindavk/chitra-d/compare/v0.2.0...HEAD
[v0.1.0]: https://github.com/aravindavk/chitra-d/compare/17ba479...v0.1.0
[v0.1.1]: https://github.com/aravindavk/chitra-d/compare/v0.1.0...v0.1.1
[v0.1.1]: https://github.com/aravindavk/chitra-d/compare/v0.1.1...v0.2.0
