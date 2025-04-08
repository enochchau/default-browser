# default-browser

Command line tool to set the default http handler in OSX.
Uses up to date APIs, compatible with macOS 12 and later.

## Build

```sh
swift build -c release
```

## Usage

List http handlers:

```sh
> default-browser
* firefox
google_chrome
safari
```

Change default http handler

```sh
default-browser google_chrome
```

## Related

- [kerma/defaultbrowser](https://github.com/kerma/defaultbrowser)
- [jwbargsten/defbro](https://github.com/jwbargsten/defbro)

This cli uses thhe [`NSWorkspace`](https://developer.apple.com/documentation/appkit/nsworkspace) APIs rather than the deprecated [Launch Services APIs](https://developer.apple.com/documentation/coreservices/launch_services).
