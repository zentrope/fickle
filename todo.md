# Work to be done, ideas, etc

## Active

- [ ] Add a context menu for each row (set dark/light pref)
- [ ] Use a superimposed circle or triangle to indicate theme. Double-click to toggle
- [ ] Ignore non image URLs
- [ ] App icon
- [ ] On start up, detect image and theme, pre-select in viewer if found
- [ ] Float dismiss control over top of table?
- [ ] Debug table view row move issue


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
- [x] Add drag and drop to acquire background images (works in App Sandbox?)
- [x] Figure out how to set the desktop image (NSWorkspace)
- [x] Model for storing list of images and appearance modes
- [x] Refactor dropview out of ViewController to its own subclass thing
- [x] How to drop on rows to move in between rows
- [x] Does NSTableView need to implement drop stuff for things outside the table?
- [x] Make sure list of themes contains no duplicates
- [x] Save themes to disk, and reload, accounting for App Sandbox
- [x] Saving themes should be on a background thread.
- [x] Loading themes should be on a background thread
- [x] Add a context menu for each row (delete)
- [x] Add a context menu for each row (exec)
- [x] Add a context menu for each row (show in finder)
- [x] Position window just under menubar, no spacing
- [x] Model image selection after Photos (rounded rect, offset border for actual image)
- [x] Change show in finder to reveal in finder
- [x] Replace quit button with popup menu: quit, open desktop pics
- [x] Offer to open folder `/Library/Desktop Pictures` (action submenu)
- [x] Remove border from action menu, maybe toggle, too.
