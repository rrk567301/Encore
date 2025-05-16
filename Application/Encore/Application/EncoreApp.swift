//
//  EncoreApp.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

// TODO: dont sent notif when not playing
// TODO: cache the tracks
// TODO: fix the localizations (fallback)
// TODO: improve the preferences layout (live progress timestamps, add tips, add preview buttons, fixed preferences window size)
// TODO: implement launch at login
// TODO: implement disable logging
// TODO: preferences (presets [local, cloud, custom {detect currently playing app} | use localized or custom name for preset | type {song, content or game} | what to display on the status | custom search api button], show odesli button, cover provider [itunes, encore], use data from the app id [top title and appicon])
// TODO: implement sparkle
// TODO: add website support

// TODO: app icon & menu bar icon
// TODO: add documentation
// TODO: tag the swiftrpc package
// TODO: tag the cache package
// TODO: list features in the readme
// TODO: document that seeking back to the beginning of the song isn't recognized due to the previous "elapsed time" being 0 before and after seeking, unless the user has manually seeked before

@main
internal struct EncoreApp: App {
    private let bridge: EncoreCoreBridge = .init()

    internal var body: some Scene {
        MenuBarExtra(Bundle.main.bundleName ?? "", systemImage: "music.note") {
            MenuBarView(bridge: self.bridge)
        }

        WindowGroup("Preferences", id: "preferences") {
            PreferencesView(bridge: self.bridge)
        }
        .handlesExternalEvents(matching: ["preferences"])
    }
}
