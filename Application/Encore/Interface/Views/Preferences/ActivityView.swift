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
        HStack {
            if let _ = self.bridge.applicationBundleIdentifier {
                DynamicCoverView(bridge: self.bridge)

                VStack(alignment: .leading) {
                    Text(self.bridge.title!)
                        .font(.custom("Noto Sans", size: 14))
                        .fontWeight(.bold)
                    Text(self.bridge.subtitle!)
                        .font(.custom("Noto Sans", size: 12))
                    Text(self.bridge.details!)
                        .font(.custom("Noto Sans", size: 12))

                    HStack(alignment: .center) {
                        Text("\(self.bridge.elapsed!)")
                            .font(.custom("Noto Sans", size: 12))
                            .monospaced()
                        Text("\(self.bridge.duration!)")
                            .font(.custom("Noto Sans Mono", size: 12))
                    }
                }
            } else {
                StaticCoverView()

                VStack(alignment: .leading) {
                    Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)
                        .font(.custom("Noto Sans", size: 14))
                        .fontWeight(.bold)
                    Text("MAINTAINER")
                        .font(.custom("Noto Sans", size: 12))
                    Text(String(format: String(localized: "VERSION"), Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String))
                        .font(.custom("Noto Sans", size: 12))

                    HStack(alignment: .center) {
                        Text("©")
                            .font(.custom("Noto Sans", size: 12))
                            .monospaced()
                        Text("\(String(describing: Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year))")
                            .font(.custom("Noto Sans Mono", size: 12))
                    }
                }
            }
        }
        .padding(UIBridge.kScreenSpacing)
    }
}

internal struct StaticCoverView: View {
    internal var body: some View {
        Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
            .antialiased(true)
            .frame(width: 100, height: 100)
            .cornerRadius(8)
    }
}

internal struct DynamicCoverView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        AsyncImage(url: self.bridge.coverUrl, content: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }, placeholder: {
            Color.secondary
        })
        .frame(width: 100, height: 100)
        .cornerRadius(8)
    }
}
