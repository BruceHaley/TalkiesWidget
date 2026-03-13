# TalkiesWidget — iOS WidgetKit App

A native iOS app that lets the user pick a name from a list. The chosen name is displayed on a Home Screen widget (small, medium, and large sizes) and embedded in a deep link (`namewidget://open?name=<chosen_name>`). Tapping the widget opens the app via that deep link.

---

## Requirements

| Tool | Version |
|------|---------|
| Xcode | 15.0+ |
| iOS Deployment Target | 17.0+ |
| Apple Developer Account | Required for device install |

---

## Setup (5 steps)

### 1. Open the project
```
open TalkiesWidget.xcodeproj
```

### 2. Set your Team & Bundle IDs

In Xcode, select the **TalkiesWidget** project in the navigator, then:

- **TalkiesWidget target → Signing & Capabilities**
  - Set *Team* to your Apple Developer account
  - Bundle Identifier: `com.yourcompany.namewidget` *(change `yourcompany`)*

- **TalkiesWidgetExtension target → Signing & Capabilities**
  - Set *Team* to the same account
  - Bundle Identifier: `com.yourcompany.namewidget.extension`

### 3. Configure the App Group

Both targets need the **same** App Group so they can share the chosen name via `UserDefaults`.

For **each** target (TalkiesWidget + TalkiesWidgetExtension):
1. Go to *Signing & Capabilities*
2. Click **+ Capability** → add **App Groups**
3. Add the group: `group.com.yourcompany.namewidget`

Then open `SharedStore.swift` (both copies) and make sure the `appGroupID` constant matches:
```swift
static let appGroupID = "group.com.yourcompany.namewidget"
```

### 4. Build & Run

Select your iPhone as the destination and press **⌘R**.

### 5. Add the widget to your Home Screen

1. Long-press the Home Screen → tap **+**
2. Search for **TalkiesWidget**
3. Choose a size (small / medium / large) and tap *Add Widget*

---

## How it works

```
User picks name in app
        │
        ▼
SharedStore.selectedName = name   ← writes to App Group UserDefaults
        │
        ▼
WidgetCenter.reloadAllTimelines() ← tells WidgetKit to refresh
        │
        ▼
NameProvider.getTimeline()        ← widget reads SharedStore.selectedName
        │
        ▼
Widget renders name + deep link
        │
        ▼
User taps widget → namewidget://open?name=Alex → app opens
```

### Deep link format
```
namewidget://open?name=<URL-encoded name>
```
Example: `namewidget://open?name=Jordan`

The URL scheme `namewidget` is registered in `Info.plist` and handled in `TalkiesWidgetApp.swift`.

---

## Customisation

| What | Where |
|------|-------|
| Name list | `ContentView.swift` → `let names = [...]` |
| Deep link scheme | `Info.plist` + `TalkiesWidgetExtension.swift` `deepLink` var |
| Widget colours | `TalkiesWidgetExtension.swift` — change the hex values in `LinearGradient` |
| App Group ID | `SharedStore.swift` (both copies) + Xcode Capabilities |
| Bundle ID | Xcode *Signing & Capabilities* for both targets |

---

## File structure

```
TalkiesWidget/
├── TalkiesWidget.xcodeproj/
├── TalkiesWidget/                  ← Main app target
│   ├── TalkiesWidgetApp.swift      ← @main, handles deep links
│   ├── ContentView.swift        ← Name picker UI
│   ├── SharedStore.swift        ← App Group UserDefaults wrapper
│   ├── Color+Hex.swift          ← Hex color convenience init
│   ├── Assets.xcassets/
│   └── Info.plist               ← URL scheme registration
└── TalkiesWidgetExtension/         ← Widget extension target
    ├── TalkiesWidgetExtension.swift ← Timeline provider + all widget views
    ├── SharedStore.swift        ← Same helper (separate compile unit)
    ├── Color+Hex.swift
    └── Assets.xcassets/
```
