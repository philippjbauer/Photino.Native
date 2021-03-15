# Photino.Native v2

The unofficial version 2 of Photino.Native.

---

For the current state of development and documentation go to https://www.tryphotino.io!

---

This is a testing ground for improving the original, experimental code by Steve Sanderson. Parts of this code will be transported over to v1 over time. We are trying to not break v1 at this point, but eyeing the release of v2 is a worthy goal, even if it remains the learning experience of using C++ and Objective-C.

Quite a bit of the original functionality is already present. But the implementation will remain macOS only for a little while. Learning Obj-C/Cocoa was enough for the moment. The resulting header files can be separated out and made available for the implementation in gtk and win32.

---

<table border="0" cellpadding="0px" cellspacing="10px">
    <tr>
        <td align="center" bgcolor="#333" width="300">
            <a href="https://www.youtube.com/watch?v=ApMFRFwYCB4">
                <img src="https://img.youtube.com/vi/ApMFRFwYCB4/0.jpg" alt="Photino.Native v2 Demo">
                <h3>1<small><sup>st</sup></small> UI Interaction Demo</h3>
            </a>
        </td>
        <td>
        <td align="center" bgcolor="#333" width="300">
            <a href="https://www.youtube.com/watch?v=mx54OoIOyjM">
                <img src="https://img.youtube.com/vi/mx54OoIOyjM/0.jpg" alt="Photino.Native v2 Demo 2">
                <h3>2<small><sup>nd</sup></small> UI Interaction Demo</h3>
            </a>
        </td>
    </tr>
</table>

---

## ToDos
- [x] Photino App 
- [x] Photino Window
- [x] WebView
- [x] Event System
- [ ] EventActions with multiple arguments (not just sender + optional string)
- [ ] App / Window Menu
- [ ] Dock (macOS only)
- [x] Alert Windows (Issue with WebView content reload after closing)
- [x] Add events to App 
- [x] Add events to Window 
- [x] Add events to WebView
- [ ] Load JavaScript into WebView from File (almost there)
- [ ] Separate the header files from the implementation
- [ ] Win32 Implementation ([Get Started](https://docs.microsoft.com/en-us/windows/win32/learnwin32/learn-to-program-for-windows))
- [ ] GTK4 Implementation ([Get Started](https://www.gtk.org/docs/))
- [ ] iOS Implementation (How?)
- [ ] Android Implementation (How?)
- [ ] Improved macOS App Bundling (dynamic name, eg.)

More to-dos will be added soon.