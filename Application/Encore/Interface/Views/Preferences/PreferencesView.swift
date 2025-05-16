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
import LaunchAtLogin

internal struct PreferencesView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge
    private let contentWidth: CGFloat = 350
    private let contentHeight: CGFloat = 500

    @State private var isOn1: Bool = true
    @State private var isOn2: Bool = false

    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ActivityView(bridge: self.bridge)
            Text("PREFERENCES_TEXT_PREVIEW_DESCRIPTION".localizedWithEnglishFallback(Bundle.main.bundleName ?? ""))
                .settingDescription()

            Divider()
                .padding(.vertical, UIBridge.kItemSpacing)

            Settings.Container(contentWidth: contentWidth) {
                Settings.Section(title: "PREFERENCES_SECTION_GENERAL".localizedWithEnglishFallback()) {
                    LaunchAtLogin.Toggle("PREFERENCES_OPTION_LAUNCH_AT_LOGIN".localizedWithEnglishFallback())
                    Toggle("PREFERENCES_OPTION_CACHING".localizedWithEnglishFallback(), isOn: $isOn1)
                        .padding(.bottom, UIBridge.kItemSpacing)
                }

                Settings.Section(title: "PREFERENCES_SECTION_MISCELLANEOUS".localizedWithEnglishFallback()) {
                    Toggle("PREFERENCES_OPTION_LOGGING".localizedWithEnglishFallback(), isOn: $isOn2)
                    Text("PREFERENCES_OPTION_LOGGING_DESCRIPTION".localizedWithEnglishFallback())
                        .settingDescription()
                    Button("PREFERENCES_ACTION_OPEN_LOGS_FOLDER".localizedWithEnglishFallback()) {
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
