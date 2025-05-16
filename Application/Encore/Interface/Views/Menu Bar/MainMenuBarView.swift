//
//  MainMenuBarView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct MainMenuBarView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack {
            let _ = print(self.bridge.applicationBundleIdentifier)
            if let bundleIdentifier: String = self.bridge.applicationBundleIdentifier {
                if let isPlaying: Bool = self.bridge.isPlaying {
                    if isPlaying {
                        Text("MAIN_MENU_BAR_NOW_PLAYING")

                        if let title: String = self.bridge.title {
                            Text(title)
                        }

                        if let details: String = self.constructDetailsText() {
                            Text(details)
                        }
                    } else {
                        Text("MAIN_MENU_BAR_PAUSED")
                    }
                }

                let applications: [NSRunningApplication] = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
                if let application: NSRunningApplication = applications.first {
                    if let applicationUrl: URL = application.bundleURL, let applicationDisplayName: String = application.localizedName {
                        Button(String(format: String(localized: "MAIN_MENU_BAR_OPEN_NOW_PLAYING_APPLICATION"), applicationDisplayName)) {
                            NSWorkspace.shared.openApplication(at: applicationUrl, configuration: NSWorkspace.OpenConfiguration())
                        }
                        .keyboardShortcut("O", modifiers: [.command])
                    }
                }
            } else {
                Text("MAIN_MENU_BAR_NOT_PLAYING")
            }

            Divider()

            Button(String(format: String(localized: "MAIN_MENU_BAR_ABOUT"), Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)) {
                NSApp.orderFrontStandardAboutPanel()
            }
            Button("MAIN_MENU_BAR_PREFERENCES") {
                NSWorkspace.shared.open(URL(string: "encore://preferences")!)
            }
            .keyboardShortcut(.init(",", modifiers: [.command]))

            Divider()

            Button(String(format: String(localized: "MAIN_MENU_BAR_QUIT"), Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)) {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut(.init("q", modifiers: [.command]))
        }
    }

    private func constructDetailsText() -> String? {
        var detailsText: String? = nil

        if let subtitle = self.bridge.subtitle {
            detailsText = "\(subtitle)"
        }

        if let details = self.bridge.details {
            if var currentDetails = detailsText {
                currentDetails += " — \(details)"
                detailsText = currentDetails
            } else {
                detailsText = details
            }
        }

        return detailsText
    }
}
