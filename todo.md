# todo

## Active

- [ ] Add drag and drop to acquire background images (works in App Sandbox?)
- [ ] Figure out how to set the desktop image (NSWorkspace)
- [ ] Model for storing list of images and appearance modes
- [ ] Add a context menu for each row (exec, set dark/light pref, delete)
- [ ] Use a superimposed circle to indicate theme. Double-click to toggle

## Done

- [x] Go fully programmatic (no storyboards)
- [x] Coordinator should contain references to window
- [x] Rename coordinator (that's not what it does)
- [x] Dark mode observer should shift light/dark switcher controls
- [x] Add a quit button
- [x] Make sure close button works when window not in focus
- [x] Make apple script `let` private (FickleApp)
- [x] Log "script executed" if no message returned (FickleApp)
- [x] Remove "isDark" property from view controller (MainViewController)
- [x] View controller should observe stock view's `effectiveApperance`, no sub-class (MainViewController)
- [x] Removed "user clicked" log messages (MainViewController)
- [x] Change pragma "coordinator" to "app controller" or something like that. (MainViewController)
- [x] Remove button.target = self in `viewDidLoad()` (MainViewController)
- [x] Rename FickleApp to AppController?
- [x] Rename `MainViewController` to `ViewController`?
- [x] Don’t send “dark” script if already dark
