# ChessGame

## A very Chess game for macOS, in the form of an executable Swift package, built with Cursor.AI.

### Screenshot
<img width="509" alt="Screenshot 2025-01-01 at 8 35 51 PM" src="https://github.com/user-attachments/assets/69248cec-5f9c-4840-b09e-f93e5bc84555" />

### How It Was Made

This, admittedly very basic, Chess game was built almost entirely using Cursor.AI.  I didn't write a single line of code (so far!), so everything here was generated as a result of various AI prompts and interactions, all with the "Cursor" macOS app.  The only exception are the images of the pieces themselves.  I pulled those from somewhere (maybe wikimedia?) and renamed them to names the AI had requested.  Cursor also made the asset catalog entries, though in looking at it now, it seems odd that the images themselves are just in the root and not down in the Resources folder
### How to Build and Run

1. Clone this repo
2. Open the Package.json in Xcode
3. Make the destination your Mac, and then do Build and Run (Command-R)

*Note: We should be able to run this from the build script or using "swift build", but for some reason when I do that, the Assets.xcassets doesn't get processed into a .car file, and SwiftUI can't find any of the images. What's up with that?  Anybody know why?*

Anyway, I'm placing this initial version here as a point-in-time example of what current AI coding tools can do.

### Limitations and Issues

1. Well, White goes first of course, but the computer won't make the first move, so right now you need to move the white piece first, and then move a black piece.  After that, white will take its turn automatically.

2. To move, you need to click on the piece you want to move, then click on the new square.  However, there's no way to reset the selected piece, so once you've clicked one, you HAVE to move that piece.
