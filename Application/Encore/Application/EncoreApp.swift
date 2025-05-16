//
//  EncoreApp.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

// TODO: improve the preferences layout (extract common values, live progress timestamps, add tips, add preview buttons, fixed preferences window size)
// TODO: implement disable caching
// TODO: implement disable logging
// TODO: preferences (presets [local, cloud, custom {detect currently playing app} | use localized or custom name for preset | type {song, content or game} | what to display on the status | custom search api button], show odesli button, cover provider [itunes, encore] {}, use data from the app id [top title and appicon])
// TODO: implement sparkle
// TODO: add website support

// TODO: app icon & menu bar icon
// TODO: add documentation

@main
internal struct EncoreApp: App {
    private let bridge: EncoreCoreBridge = .init()

    internal var body: some Scene {
        MenuBarExtra(Bundle.main.bundleName ?? "", systemImage: "music.note") {
            MenuBarView(bridge: self.bridge)
        }

        WindowGroup("PREFERENCES_TEXT_PREFERENCES".localizedWithEnglishFallback(), id: "preferences") {
            PreferencesView(bridge: self.bridge)
        }
        .handlesExternalEvents(matching: ["preferences"])
    }
}
