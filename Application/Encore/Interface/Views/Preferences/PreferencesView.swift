import SwiftUI
import Settings

struct AccountsScreen: View {
    @State private var isOn1 = true
    @State private var isOn2 = false
    @State private var isOn3 = true
    @State private var selection1 = 1
    @State private var selection2 = 0
    @State private var selection3 = 0
    @State private var isExpanded = false
    private let contentWidth: Double = 450.0

    var body: some View {
        Settings.Container(contentWidth: contentWidth) {
            Settings.Section(title: "Permissions:") {
                Toggle("Allow user to administer this computer", isOn: $isOn1)
                Text("Administrator has root access to this machine.")
                    .settingDescription()
                Toggle("Allow user to access every file", isOn: $isOn2)
            }
            Settings.Section(title: "Show scroll bars:") {
                Picker("", selection: $selection1) {
                    Text("When scrolling").tag(0)
                    Text("Always").tag(1)
                }
                    .labelsHidden()
                    .pickerStyle(.radioGroup)
            }
            Settings.Section(label: {
                Toggle("Some toggle", isOn: $isOn3)
            }) {
                Picker("", selection: $selection2) {
                    Text("Automatic").tag(0)
                    Text("Manual").tag(1)
                }
                    .labelsHidden()
                    .frame(width: 120.0)
                Text("Automatic mode can slow things down.")
                    .settingDescription()
            }
            Settings.Section(title: "Preview mode:") {
                Picker("", selection: $selection3) {
                    Text("Automatic").tag(0)
                    Text("Manual").tag(1)
                }
                    .labelsHidden()
                    .frame(width: 120.0)
                Text("Automatic mode can slow things down.")
                    .settingDescription()
            }
            Settings.Section(title: "Expand this pane:") {
                Toggle("Expand", isOn: $isExpanded)
                if isExpanded {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                        Text("🦄")
                            .frame(width: 180, height: 180)
                    }
                }
            }
        }
    }
}
