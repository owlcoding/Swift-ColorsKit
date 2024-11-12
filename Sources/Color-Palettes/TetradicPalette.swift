import SwiftUI

extension Color {

    /// Iterator for generating a tetradic color palette around a given color.
    ///
    /// This iterator generates a tetradic color palette by utilizing the `AnalogousPaletteIterator`. It alternates between
    /// colors shifted in four directions from the base color, and each time `next()` is called, it returns one color from
    /// the tetradic palette.
    ///
    /// Example usage:
    /// ```swift
    /// let baseColor = Color.red
    /// var iterator = TetradicPaletteIterator(color: baseColor)
    ///
    /// if let color = iterator.next() {
    ///     print("Tetradic Color: \(color)")
    /// }
    /// ```
    /// This returns one tetradic color from the palette at a time.
    ///
    /// - Parameters:
    ///   - color: The base `Color` to generate the tetradic palette from.
    ///   - allowBrightnessChange: A `Bool` indicating whether brightness adjustments should be allowed. Default is `true`.
    ///   - hueAdjustmentDirection: A `HueAdjustmentDirection` enum indicating the hue shift direction. Default is `.closer`.
    ///
    /// - Returns: A `TetradicPaletteIterator` to iterate over the tetradic color palette.
    public struct TetradicPaletteIterator: IteratorProtocol, Sequence {
        public static var paletteName: String { "Tetradic" }
        private var iterator: AnalogousPaletteIterator
        private let color: Color
        private let allowBrightnessChange: Bool

        init(
            color: Color, allowBrightnessChange: Bool = true,
            hueAdjustmentDirection: AnalogousPaletteIterator
                .HueAdjustmentDirection = .closer
        ) {
            self.color = color
            self.allowBrightnessChange = allowBrightnessChange
            self.iterator = AnalogousPaletteIterator(
                color: color, allowBrightnessChange: allowBrightnessChange,
                initialHueChange: 90.0,
                hueAdjustmentDirection: hueAdjustmentDirection)
        }

        public init(color: Color, allowBrightnessChange: Bool = true) {
            self.init(
                color: color, allowBrightnessChange: allowBrightnessChange,
                hueAdjustmentDirection: .closer)
        }

        /// Returns the next tetradic color from the palette.
        ///
        /// - Returns: A `Color` object representing the next tetradic color, or `nil` if the end of the palette is reached.
        public mutating func next() -> Color? {
            iterator.next()
        }
    }
}
