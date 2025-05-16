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
    private let contentWidth: CGFloat = 350
    private let contentHeight: CGFloat = 500

    @State private var isOn1: Bool = true
    @State private var isOn2: Bool = false

    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ActivityView(bridge: self.bridge)
            Text(String(format: String(localized: "PREFERENCES_TEXT_PREVIEW_DESCRIPTION"), Bundle.main.bundleName ?? ""))
                .settingDescription()

            Divider()
                .padding(.vertical, UIBridge.kItemSpacing)

            Settings.Container(contentWidth: contentWidth) {
                Settings.Section(title: "General:") {
                    Toggle("PREFERENCES_OPTION_START_AT_LOGIN", isOn: $isOn1)
                        .padding(.bottom, UIBridge.kItemSpacing)
                }

                Settings.Section(title: "Miscellaneous:") {
                    Toggle("PREFERENCES_OPTION_LOGGING", isOn: $isOn2)
                    Text("PREFERENCES_OPTION_LOGGING_DESCRIPTION")
                        .settingDescription()
                    Button("PREFERENCES_ACTION_OPEN_LOGS_DIRECTORY") {
                        Logger.sharedInstance().ensureFileSystem()
                        NSWorkspace.shared.open(URL(fileURLWithPath: Logger.sharedInstance().logsPath()))
                    }
                }
            }
        }
        .frame(minWidth: self.contentWidth, maxWidth: .infinity, minHeight: contentHeight, alignment: .topLeading)
        .padding(UIBridge.kScreenSpacing)
    }
}
