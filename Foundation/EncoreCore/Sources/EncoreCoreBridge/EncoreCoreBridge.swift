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
    @Published public var duration: CGFloat? = nil
    @Published public var elapsed: CGFloat? = nil

    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingInfoChanged), name: Notification.Name(kNotificationNameNowPlayingInfoChanged), object: nil)
    }

    @objc private func nowPlayingInfoChanged(notification: Notification) -> Void {
        guard let media = self.core.media else {
            // Set all properties to nil when media is nil
            self.applicationBundleIdentifier = nil
            self.isPlaying = nil
            self.title = nil
            self.subtitle = nil
            self.details = nil
            self.duration = nil
            self.elapsed = nil
            return
        }

        // Assign values from media when it's not nil
        self.applicationBundleIdentifier = media.applicationBundleIdentifier
        self.isPlaying = media.isPlaying
        self.title = media.title
        self.subtitle = media.subtitle
        self.details = media.details
        self.duration = media.duration
        self.elapsed = media.elapsed
    }
}
