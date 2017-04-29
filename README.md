# FaceyFindy

This iPhone app allows you to train and use a facial recognition model with your camera.

<img src="https://raw.githubusercontent.com/notduncansmith/faceyfindy/master/ffdemo-480p.gif" />

## How it works

Detected faces appear in the bottom-right panel.

When in training mode (indicated by the red switch), detected faces will be added to the recognition model.

Once at least 5 training images have been saved, each face detected in recognition mode will be evaluated for distance from the model.

When you close the app, any gathered training data will not be saved.

## Limitations

As it is currently at the proof-of-concept stage, this app only trains/evaluates one model per session, and does not persist models between sessions.

Having even lighting across the subject's face, and especially having them smile at least somewhat open-mouthed helps a lot with face detection. This functionality is provided by the native face detection capabilities of iOS, which are specifically adapted for face detection in photos people take with their phone, so it makes sense. Most photos are of people smiling.

Also, it's not terribly accurate. This is mostly because it's easy to blur the photos as one captures, and the current cropping solution doesn't attempt to cut out background noise.

Finally, don't use this app your phone's sound on, as the continuous shutter sound is quite obnoxious - I'd love to get rid of it eventually, but right now it seems like [more trouble than it's worth](http://stackoverflow.com/questions/4401232/avfoundation-how-to-turn-off-the-shutter-sound-when-capturestillimageasynchrono).

## Future enhancements

[ ] Support multiple (saved/named) models

[ ] Support non-camera data sources (image search, Facebook friends, etc)

[ ] Support pruning model inputs (editable photo grid or something)

[ ] Include models for a few well-known faces

[ ] Add automated tests for functionality and accuracy

[ ] Improve accuracy (face detection and recognition)

[ ] Improve prediction UI (as 🔥 as a rapid stream of labels is, it'd be neat to have something more organic-feeling)

## Learnings

- iOS drawing and graphics systems

- Processing images with `CoreImage` and `CGAffineTransform`s

  - This was harder than it looked by a mile. Many online tutorials for drawing boxes around faces fail to correctly handle image orientation, but look like they work because they're tested on non-mirrored stock images where a face appears dead-center and thus fails to reveal orientation issues.

- Debug/etc flags in Swift projects (more convenient than they used to be, apparently)

- Theory and practical application of various facial recognition algorithms, including Eigenfaces, Fisherfaces, and Local Binary Pattern Histograms (LBPH)

- C++ library (OpenCV) integration with Swift via Objective-C++

- Every nook and cranny of Elon Musk's face, courtesy of the development process
