# Trackpad Touches

SwiftUI macOS app that shows the number of fingers on the trackpad and each
finger's normalized position.

Uses the public AppKit touch API (`allowedTouchTypes = [.indirect]`,
`wantsRestingTouches`), so no private framework and no Accessibility permission.

## Build & run

```sh
./build-app.sh
open TrackpadTouches.app
```

Or during development:

```sh
swift run
```

## Notes

- Keep the window focused; trackpad touches are delivered to the focused view.
- Positions are normalized `0…1`, origin at the lower-left of the trackpad.
- `wantsRestingTouches` is on, so fingers still resting on the pad are counted.
- Tested on macOS 27 / Apple Silicon. The API is deprecated since 10.12.2 in
  favour of `allowedTouchTypes`, which this app uses.
