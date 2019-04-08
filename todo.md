# todo

## Active

- [ ] Add drag and drop to acquire background images (works in App Sandbox?)
- [ ] Figure out how to set the desktop image (NSWorkspace)
- [ ] Model for storing list of images and appearance modes
- [ ] Add a context menu for each row (exec, set dark/light pref, delete)

## Code review

- [ ] Make apple script var private (FickleApp)
- [ ] Log "script executed" if no message returned (FickleApp)
- [ ] Remove "isDark" property from view controller (MainViewController)
- [ ] View controller should observe stock view's `effectiveApperance`, no sub-class (MainViewController)
- [ ] Removed "user clicked" log messages (MainViewController)
- [ ] Change pragma "coordinator" to "app controller" or something like that. (MainViewController)
- [ ] Renamed FickleApp to AppController?
- [ ] Remove button.target = self in `viewDidLoad()` (MainViewController)
- [ ] Rename "MainViewController" to "ViewController"?

## Done

- [x] Go fully programmatic (no storyboards)
- [x] Coordinator should contain references to window
- [x] Rename coordinator (that's not what it does)
- [x] Dark mode observer should shift light/dark switcher controls
- [x] Add a quit button
- [x] Make sure close button works when window not in focus
