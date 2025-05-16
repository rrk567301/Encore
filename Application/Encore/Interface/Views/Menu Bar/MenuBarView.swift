//
//  MenuBarView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct MenuBarView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack {
            if let bundleIdentifier: String = self.bridge.applicationBundleIdentifier {
                if let isPlaying: Bool = self.bridge.isPlaying {
                    if isPlaying {
                        Text("MENU_BAR_NOW_PLAYING".localizedWithEnglishFallback())

                        if let title: String = self.bridge.title {
                            Text(title)
                        }

                        if let details: String = self.constructDetailsText() {
                            Text(details)
                        }
                    } else {
                        Text("MENU_BAR_PAUSED".localizedWithEnglishFallback())
                    }
                }

                let applications: [NSRunningApplication] = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
                if let application: NSRunningApplication = applications.first {
                    if let applicationUrl: URL = application.bundleURL, let applicationDisplayName: String = application.localizedName {
                        Button("MENU_BAR_OPEN_NOW_PLAYING_APPLICATION".localizedWithEnglishFallback(applicationDisplayName)) {
                            NSWorkspace.shared.openApplication(at: applicationUrl, configuration: NSWorkspace.OpenConfiguration())
                        }
                        .keyboardShortcut("O", modifiers: [.command])
                    }
                }
            } else {
                Text("MENU_BAR_NOT_PLAYING".localizedWithEnglishFallback())
            }

            Divider()

            Button("MENU_BAR_ABOUT".localizedWithEnglishFallback(Bundle.main.bundleName ?? "")) {
                NSApp.orderFrontStandardAboutPanel()
            }
            Button("MENU_BAR_PREFERENCES".localizedWithEnglishFallback()) {
                NSWorkspace.shared.open(URL(string: "encore://preferences")!)
            }
            .keyboardShortcut(.init(",", modifiers: [.command]))

            Divider()

            Button("MENU_BAR_QUIT".localizedWithEnglishFallback(Bundle.main.bundleName ?? "")) {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut(.init("Q", modifiers: [.command]))
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
