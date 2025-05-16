//
//  EncoreApp.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

// TODO: improve the logs
// TODO: dont sent notif when not playing
// TODO: rewrite the data fetching (odesli button, cache the track)
// TODO: tag the swiftrpc package
// TODO: tag the cache package
// TODO: preferences (launch at login, disable logging, presets [local, cloud, custom {detect currently playing app} | use localized or custom name for preset | type {song, content or game} | what to display on the status | custom search api button], show odesli button, cover provider [itunes, encore])
// TODO: add website support
// TODO: add lastfm scrobbling

// TODO: app icon & menu bar icon
// TODO: add documentation
// TODO: document that seeking back to the beginning of the song isn't recognized due to the previous "elapsed time" being 0 before and after seeking, unless the user has manually seeked before

@main
internal struct EncoreApp: App {
    private let bridge: EncoreCoreBridge = .init()

    internal var body: some Scene {
        MenuBarExtra(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String, systemImage: "music.note") {
            MainMenuBarView(bridge: self.bridge)
        }

        WindowGroup("Preferences", id: "preferences") {
            PreferencesView(bridge: self.bridge)
        }
        .handlesExternalEvents(matching: ["preferences"])
    }
}
