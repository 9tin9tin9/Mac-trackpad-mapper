# Trackpad mapper for Mac

This utility maps finger position on trackpad to curosr coordinate on screen.

- [x] Lightweight
- [x] Does not create window
- [x] Highly configurable
- [x] Status bar app for easy toggling absolute tracking

I personally use this to play Osu! on Mac with trackpad.

## Modifying rule
There is a function `map` in `settings.h` that converts normalized finger
position on trackpad to absolute coordinate of cursor on Screen.
`MTPoint map(double, double)` must be provided in `settings.h` as it will be
called in `trackpad_mapper_util.c`.

```C
MTPoint map(double normx, double normy) {
    // whole trackpad to whole screen
    MTPoint point = {
        normx * screenSize.x, normy * screenSize.y
    };
    return point;
}
```

Example code to map to top right quarter of trackpad to whole screen

```C
MTPoint map(double normx, double normy) {
    // top right quarter of the area of trackpad to whole screen
    MTPoint point = {
        .x = normx >= 0.5 ? ((normx - 0.5) / 0.5) : 0,
        .y = normy <= 0.5 ? (normy / 0.5) : 1,
    };
    point.x *= screenSize.x;
    point.y *= screenSize.y;
    return point;
}
```

Remember to rebuild the util everytime you changed `map`.

## Screen Size
This code does not detect screen size. Instead there is a global constant that
keeps track of screen size.

```C
const MTPoint screenSize = { .x = 1440, .y = 900 };
```

Modifying this constant changes screen size.

Note that **trackpad mapper** does not validate screen size nor cursor
coordinate. It is feed directly to mouse event and posted to event tab.

## Building

To compile, run
```sh
make release
```

The app is located in `build/`.

You may want to copy the app to the `/Applications/` folder or run
```sh
make install
```
to do it for you.

## Rebuilding Util

After you modified `map`, run
```sh
make util_release install_util_update
```
This will compile and update the util binary in the app bundle inside `/Applications/`

## TODO List

- [x] Create an app that can toggle absolute tracking
- [ ] Better way to change mapping rule

## Reference
Where I got the MultitouchSupport.h header
https://gist.github.com/rmhsilva/61cc45587ed34707da34818a76476e11
