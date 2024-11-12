import SwiftUI

import ColorExtensions

//extension Color.Palette {
//    public static var hashable: AnyHashable {
//        AnyHashable(Self.paletteName)
//    }
//}
//
//func hashable(from iterator: Color.AnalogousPaletteIterator) -> AnyHashable {
//    AnyHashable(iterator.hashValue)
//}

extension Color {
    /// Iterator for generating an analogous color palette around a given color.
    ///
    /// This iterator generates an analogous color palette by shifting the hue of the selected color in both directions.
    /// In each iteration, it alternates between colors shifted in one direction and then the other.
    /// The result is a smooth transition of colors, which can be used to create harmonious color schemes.
    ///
    /// Example usage:
    /// ```swift
    /// let baseColor = Color.green
    /// var iterator = AnalogousPaletteIterator(color: baseColor)
    ///
    /// if let color = iterator.next() {
    ///     print("Analogous Color: \(color)")
    /// }
    /// ```
    /// In this case, the iterator will return one color at a time, alternating between colors shifted to the left and right.
    ///
    /// - Parameters:
    ///   - color: The base `Color` to generate the analogous palette from.
    ///   - allowBrightnessChange: A `Bool` indicating whether the brightness of the colors should be adjusted. Default value is `true`.
    ///   - initialHueChange: The initial change in hue between color variants. Default value is 15°.
    ///   - hueAdjustmentDirection: A `HueAdjustmentDirection` enum indicating whether to shift hue further or closer. The default is `.further`.
    ///
    /// - Returns: An `AnalogousPaletteIterator` object to iterate over the analogous palette.
    public struct AnalogousPaletteIterator: IteratorProtocol, Sequence {
        public static var paletteName: String { "Analogous" }
        private var index = 1
        private let color: Color
        private let allowBrightnessChange: Bool
        private let isMonochromePalette: Bool
        private let initialHueChange: Double
        private let hueAdjustmentDirection: HueAdjustmentDirection
        
        enum HueAdjustmentDirection: Double {
            case further = 1.0
            case closer = -1.0
        }
        
        private var isDirectionReversed = false
        
        init(color: Color, allowBrightnessChange: Bool = true, initialHueChange: Double, hueAdjustmentDirection: HueAdjustmentDirection) {
            self.color = color
            self.allowBrightnessChange = allowBrightnessChange
            self.isMonochromePalette = ColorProperties.HSBA(color).saturation < 0.1
            self.initialHueChange = initialHueChange
            self.hueAdjustmentDirection = hueAdjustmentDirection
        }
        
        public init(color: Color, allowBrightnessChange: Bool = true) {
            self.init(color: color, allowBrightnessChange: allowBrightnessChange, initialHueChange: 15, hueAdjustmentDirection: .further)
        }
        
        /// Returns a single color from the analogous palette, alternating between colors shifted in different directions.
        ///
        /// - Returns: A `Color` object, or `nil` if the end of the palette is reached.
        public mutating func next() -> Color? {
            guard index <= 8 else { return nil }
            
            let newColor = colorForIndex(index)
            
            isDirectionReversed.toggle()
            if !isDirectionReversed {
                index += 1
            }
            
            return newColor
        }
    }
}

extension Color.AnalogousPaletteIterator {
    func shift(for index: Int) -> Double {
        if index == 0 {
            return 0.0
        } else if index == 1 {
            return initialHueChange
        } else {
            let newShift = shift(for: index - 1) * (1 + 1.0 / Double(index))
            return newShift
        }
    }
    
    func hueChange(for index: Int, isDirectionReversed: Bool) -> Angle {
        Angle(degrees: shift(for: index) * hueAdjustmentDirection.rawValue * (isDirectionReversed ? -1 : 1))
    }
    
    func brightnessChange(for index: Int, isDirectionReversed: Bool) -> Double {
        shift(for: index) * hueAdjustmentDirection.rawValue * (isDirectionReversed ? -1 : 1) / 60.0
    }

    private func colorForIndex(_ index: Int) -> Color {
        if isMonochromePalette {
            return color.hsba { _, _, b, _ in
                b = Swift.max(Swift.min(b + brightnessChange(for: index, isDirectionReversed: isDirectionReversed), 1), 0)
            }
        } else {
            let newColor = color.hsba { h, _, _, _ in
                h += hueChange(for: index, isDirectionReversed: isDirectionReversed)
            }
            
            return newColor
        }
    }
}
