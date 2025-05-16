//
//  PreferencesView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct ActivityView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let _ = self.bridge.applicationBundleIdentifier {
                Text("PREFERENCES_TEXT_LISTENING_TO".localizedWithEnglishFallback("Apple Music"))
                    .font(.custom("Noto Sans", size: 12))
            } else {
                Text("PREFERENCES_TEXT_WELCOME".localizedWithEnglishFallback(Bundle.main.bundleName ?? ""))
                    .font(.custom("Noto Sans", size: 12))
            }

            HStack(spacing: 0) {
                if let _ = self.bridge.applicationBundleIdentifier {
                    DynamicCoverView(bridge: self.bridge)
                        .padding([.top, .trailing, .bottom], 12)
                    DetailsView(bridge: self.bridge, isActive: true)
                } else {
                    StaticCoverView()
                        .padding([.top, .trailing, .bottom], 12)
                    DetailsView(bridge: self.bridge, isActive: false)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct DetailsView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge
    internal let isActive: Bool

    internal var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if self.isActive {
                TextView(text: self.bridge.title ?? "", size: 14, isBold: true)
                TextView(text: self.bridge.subtitle ?? "", size: 12, isBold: false)
                TextView(text: self.bridge.details ?? "", size: 12, isBold: false)
                    .padding(.bottom, 4)

                HStack(alignment: .center, spacing: 0) {
                    TimestampView(timestamp: self.formattedTimestamp(fromSeconds: self.bridge.elapsed ?? 0))
                    ProgressBarView(progress: self.bridge.duration ?? 0 > 0 ? (self.bridge.elapsed ?? 0) / (self.bridge.duration ?? 0) : 0)
                        .frame(height: 2)
                        .padding(.horizontal, 8)
                    TimestampView(timestamp: self.formattedTimestamp(fromSeconds: self.bridge.duration ?? 0))
                }
            } else {
                TextView(text: Bundle.main.bundleName ?? "", size: 14, isBold: true)
                TextView(text: "PREFERENCES_TEXT_MAINTAINER".localizedWithEnglishFallback(), size: 12, isBold: false)
                TextView(text: "PREFERENCES_VERSION".localizedWithEnglishFallback(Bundle.main.bundleVersion ?? ""), size: 12, isBold: false)
                    .padding(.bottom, 4)

                HStack(alignment: .center, spacing: 0) {
                    TimestampView(timestamp: "PREFERENCES_TEXT_COPYRIGHT".localizedWithEnglishFallback())
                    ProgressBarView(progress: 1)
                        .frame(height: 2)
                        .padding(.horizontal, 4)
                    TimestampView(timestamp: "\(Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year ?? 0)")
                }
            }
        }
    }

    private func formattedTimestamp(fromSeconds seconds: CGFloat) -> String {
        let totalSeconds: Int = Int(seconds)
        let minutes: Int = totalSeconds / 60
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

private struct TextView: View {
    internal let text: String
    internal let size: CGFloat
    internal let isBold: Bool

    internal var body: some View {
        Text(self.text)
            .font(.custom("Noto Sans", size: self.size))
            .fontWeight(self.isBold ? .bold : .regular)
            .lineLimit(1)
    }
}

private struct TimestampView: View {
    internal let timestamp: String

    internal var body: some View {
        Text(self.timestamp)
            .font(.custom("Noto Sans Mono", size: 12))
            .contentTransition(.numericText())
    }
}

private struct ProgressBarView: View {
    internal var progress: CGFloat // Should be between 0 and 1.

    internal var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.primary.opacity(0.2))
                Capsule()
                    .fill(.primary)
                    .frame(width: geometry.size.width * self.progress)
            }
        }
    }
}

private struct StaticCoverView: View {
    internal var body: some View {
        Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
            .frame(width: 100, height: 100)
            .cornerRadius(8, antialiased: true)
    }
}

private struct DynamicCoverView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        ZStack {
            AsyncImage(url: self.bridge.coverUrl, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }, placeholder: {
                Color.secondary
            })
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            .reverseMask {
                Circle()
                    .frame(width: 40, height: 40)
                    .offset(x: 40, y: 40)
            }
            .overlay {
                Image("Apple Music")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .offset(x: 40, y: 40)
            }
        }
    }
}
