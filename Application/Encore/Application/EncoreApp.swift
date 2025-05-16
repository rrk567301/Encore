//
//  EncoreApp.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

// TODO: add caching
// TODO: tag the swiftrpc package
// TODO: preferences
// TODO: handle client ids
// TODO: check what happens if switching playing apps too rapidly (will it stay on the same client id?)
// TODO: add website support
// TODO: add lastfm scrobbling

// TODO: app icon & menu bar icon
// TODO: documentation

@main
internal struct EncoreApp: App {
    private let bridge: EncoreCoreBridge = .init()

    internal var body: some Scene {
        MenuBarExtra(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String, systemImage: "music.note") {
            MainMenuBarView(bridge: self.bridge)
        }

        WindowGroup("Preferences", id: "preferences") {
            AccountsScreen()
        }
        .handlesExternalEvents(matching: ["preferences"])
    }
}
