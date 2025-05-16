//
//  View+ReverseMask.swift
//  Encore
//
//  Created by Codelaby
//

import SwiftUI

extension View {
    internal func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}
