//
//  String+LocalizedEnglishFallback.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import Foundation

extension String {
    internal func localizedWithEnglishFallback(_ arguments: CVarArg...) -> String {
        var localizedString: String = String(localized: String.LocalizationValue(self))

        if self == localizedString {
            if let englishBundlePath: String = Bundle.main.path(forResource: "en", ofType: "lproj"), let englishBundle: Bundle = Bundle(path: englishBundlePath) {
                localizedString = String(localized: String.LocalizationValue(self), bundle: englishBundle)
            }
        }

        return String(format: localizedString, arguments: arguments)
    }
}
