//
//  EncoreCoreBridge.swift
//  EncoreCoreBridge
//
//  Created by Alexandra Göttlicher
//

import EncoreCore
import SwiftUI

public class EncoreCoreBridge: ObservableObject {
    private let core: EncoreCore = .init()

    @Published public var applicationBundleIdentifier: String? = nil
    @Published public var isPlaying: Bool? = nil
    @Published public var title: String? = nil
    @Published public var subtitle: String? = nil
    @Published public var details: String? = nil
    @Published public var coverUrl: URL? = nil
    @Published public var duration: CGFloat? = nil
    @Published public var elapsed: CGFloat? = nil

    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingInfoChanged), name: Notification.Name(kNotificationNameNowPlayingInfoChanged), object: nil)
    }

    @objc private func nowPlayingInfoChanged(notification: Notification) -> Void {
        withAnimation(.bouncy) {
            self.applicationBundleIdentifier = self.core.media?.applicationBundleIdentifier
            self.isPlaying = self.core.media?.isPlaying
            self.title = self.core.media?.title
            self.subtitle = self.core.media?.subtitle
            self.details = self.core.media?.details
            self.coverUrl = self.core.media?.coverUrl
            self.duration = self.core.media?.duration
            self.elapsed = self.core.media?.elapsed
        }
    }
}
