//
//  PreferencesView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCore
import EncoreCoreBridge
import Settings
import SwiftUI

internal struct PreferencesView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge
    private let contentWidth: Double = 200

    @State private var isOn1: Bool = true
    @State private var isOn2: Bool = false

    internal var body: some View {
        VStack {
            ActivityView(bridge: self.bridge)
            Spacer()
            Settings.Container(contentWidth: contentWidth) {
                Settings.Section(title: "General:") {
                    Toggle("Launch at boot", isOn: $isOn1)
                }
                Settings.Section(title: "Miscellaneous:") {
                    Toggle("Logging", isOn: $isOn2)
                    Text("Logging is done only on your machine and helps me with resolving bugs.")
                        .settingDescription()
                    Button("Open Logs directory") {
                        Logger.sharedInstance().ensureFileSystem()
                        NSWorkspace.shared.open(URL(fileURLWithPath: Logger.sharedInstance().logsPath()))
                    }
                }
            }
        }
    }
}
