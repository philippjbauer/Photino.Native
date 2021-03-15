# Photino.Native v2

The unofficial version 2 of Photino.Native.

---

For the current state of development and documentation go to https://www.tryphotino.io!

---

This is a testing ground for improving the original, experimental code by Steve Sanderson. Parts of this code will be transported over to v1 over time. We are trying to not break v1 at this point, but eyeing the release of v2 is a worthy goal, even if it remains the learning experience of using C++ and Objective-C.

Quite a bit of the original functionality is already present. But the implementation will remain macOS only for a little while. Learning Obj-C/Cocoa was enough for the moment. The resulting header files can be separated out and made available for the implementation in gtk and win32.

---

<style>
.p-card {
    overflow: hidden;
    background: #333;
    width: 300px;
    margin: 1em 2em 1em 0;
    color: #FFF;
    border-radius: 3px;
    box-shadow: 0 0 15px rgba(0, 0, 0, .25);
}
.p-card:hover {
    text-decoration: none;
}
    .p-card .p-card-header {
        overflow: hidden;
        position: relative;
    }
        .p-card .p-card-header::after {
            box-sizing: content;
            display: flex;
            justify-content: center;
            align-items: center;
            content: '▶';
            width: 80px;
            height: 80px;
            color: #FFF;
            font-size: 40px;
            position: absolute;
            top: calc(50% - 40px);
            left: calc(50% - 40px);
            border-radius: 50%;
            border: 5px solid #FFF;
            transition: all 0.1s linear;
        }
        .p-card:hover .p-card-header::after {
            transform: scale(0.9);
        }
        
        .p-card .p-card-header img {
            display: block;
            width: 100%;
            margin: -28px 0;
        }

    .p-card .p-card-content {
        padding: 1em 1em;
    }
        .p-card .p-card-content h3 {
            text-align: center;
        }
</style>
<div style="display: flex;">
<a class="p-card" href="https://www.youtube.com/watch?v=ApMFRFwYCB4">
    <div class="p-card-header">
        <img src="https://img.youtube.com/vi/ApMFRFwYCB4/0.jpg" alt="Photino.Native v2 Demo">
    </div>
    <div class="p-card-content">
        <h3>1<small><sup>st</sup></small> UI Interaction Demo</h3>
    </div>
</a>

<a class="p-card" href="https://www.youtube.com/watch?v=mx54OoIOyjM">
    <div class="p-card-header">
        <img src="https://img.youtube.com/vi/mx54OoIOyjM/0.jpg" alt="Photino.Native v2 Demo 2">
    </div>
    <div class="p-card-content">
        <h3>2<small><sup>nd</sup></small> UI Interaction Demo</h3>
    </div>
</a>
</div>

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