import SwiftUI

extension Color {

    /// Iterator for generating a split complementary color palette around a given color.
    ///
    /// This iterator generates a split complementary palette by utilizing the `AnalogousPaletteIterator`. It alternates
    /// between colors shifted in two directions from the base color, and each time `next()` is called, it returns one color
    /// from the palette.
    ///
    /// Example usage:
    /// ```swift
    /// let baseColor = Color.blue
    /// var iterator = SplitComplementaryPaletteIterator(color: baseColor)
    ///
    /// if let color = iterator.next() {
    ///     print("Split Complementary Color: \(color)")
    /// }
    /// ```
    /// This returns one split-complementary color from the palette at a time.
    ///
    /// - Parameters:
    ///   - color: The base `Color` to generate the split complementary palette from.
    ///   - allowBrightnessChange: A `Bool` indicating whether brightness adjustments should be allowed. Default is `true`.
    ///   - hueAdjustmentDirection: A `HueAdjustmentDirection` enum indicating the hue shift direction. Default is `.further`.
    ///
    /// - Returns: A `SplitComplementaryPaletteIterator` to iterate over the split complementary color palette.
    public struct SplitComplementaryPaletteIterator: IteratorProtocol, Sequence
    {
        public static var paletteName: String { "SplitComplementary" }

        private var iterator: AnalogousPaletteIterator
        private let color: Color
        private let allowBrightnessChange: Bool

        init(
            color: Color, allowBrightnessChange: Bool = true,
            hueAdjustmentDirection: AnalogousPaletteIterator
                .HueAdjustmentDirection = .further
        ) {
            self.color = color
            self.allowBrightnessChange = allowBrightnessChange
            self.iterator = AnalogousPaletteIterator(
                color: color, allowBrightnessChange: allowBrightnessChange,
                initialHueChange: 30.0,
                hueAdjustmentDirection: hueAdjustmentDirection)
        }

        public init(color: Color, allowBrightnessChange: Bool = true) {
            self.init(
                color: color, allowBrightnessChange: allowBrightnessChange,
                hueAdjustmentDirection: .further)
        }

        /// Returns the next split complementary color from the palette.
        ///
        /// - Returns: A `Color` object representing the next split complementary color, or `nil` if the end of the palette is reached.
        public mutating func next() -> Color? {
            iterator.next()
        }
    }
}
