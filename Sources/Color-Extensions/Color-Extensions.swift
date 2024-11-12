import SwiftUI

#if canImport(UIKit)
import UIKit
typealias PlatformColor = UIColor
extension Color {
    fileprivate var platformColor: PlatformColor? {
        PlatformColor(self)
    }
}
#elseif canImport(AppKit)
import AppKit
typealias PlatformColor = NSColor
extension Color {
    fileprivate var platformColor: PlatformColor? {
        PlatformColor(self).usingColorSpace(.deviceRGB)
    }
}
#endif

extension Color {
    var alpha: Double {
        get { PlatformColor(self).cgColor.alpha }
        set { self = self.hsba { _, _, _, a in a = newValue } }
    }

    public enum ColorProperties {
        public struct RGBA {
            public var red: Double
            public var green: Double
            public var blue: Double
            public var alpha: Double
            
            public init(_ color: Color) {
                var (red, green, blue, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
                guard let platformColor = color.platformColor
                else { fatalError("Color not convertible to RGB") }
                platformColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                self.red = Double(red)
                self.green = Double(green)
                self.blue = Double(blue)
                self.alpha = Double(alpha)
            }
            
            public init(_ red: Double, _ green: Double, _ blue: Double, alpha: Double = 1) {
                self.red = red
                self.green = green
                self.blue = blue
                self.alpha = alpha
            }
        }
        public struct HSBA {
            public var hue: Angle
            public var saturation: Double
            public var brightness: Double
            public var alpha: Double
            
            public init(_ color: Color) {
                var (hue, saturation, brightness, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
                guard let platformColor = color.platformColor
                else { fatalError("Color not convertible to HSB") }
                platformColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                self.hue = Angle(radians: 2 * Double.pi * Double(hue))
                self.saturation = Double(saturation)
                self.brightness = Double(brightness)
                self.alpha = Double(alpha)
            }
        }
    }
    
    init(hue: Angle, saturation: Double, brightness: Double, alpha: Double = 1) {
        self.init(hue: hue.degrees / Double(360), saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    var hue: Angle {
        ColorProperties.HSBA(self).hue
    }

    /// The relative brightness of the color based on its RGB values.
    ///
    /// This computed property calculates and returns the luminance, which is a measure of
    /// the perceived brightness of the color. A higher luminance indicates a lighter color.
    ///
    /// - Returns: A `CGFloat` representing the luminance in the range [0, 1].
    public var luminance: CGFloat {
        Self.luminance(from: ColorProperties.RGBA(self))
    }
    
    /// Returns a lighter variant of the color by adjusting the RGB values proportionally.
    ///
    /// This property creates a color with a higher luminance than the original. If the original
    /// color is very dark (low luminance), it defaults to a soft gray. This method maintains the
    /// color's hue and saturation while increasing its brightness.
    ///
    /// - Returns: A `Color` object that is lighter than the original.
    public var lighter: Color {
        let originalLuminance = luminance
        if originalLuminance < 0.01 {
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        }
        let targetLuminance = min(originalLuminance / 0.5, 1.0)
        let rgba = ColorProperties.RGBA(self)
        let scaleFactor = targetLuminance / (originalLuminance != 0 ? originalLuminance : 1)
        
        let newRed = min(rgba.red * scaleFactor, 1.0)
        let newGreen = min(rgba.green * scaleFactor, 1.0)
        let newBlue = min(rgba.blue * scaleFactor, 1.0)
        let newAlpha = rgba.alpha
        
        return Color(red: newRed, green: newGreen, blue: newBlue, opacity: newAlpha)
    }
    
    /// Returns a darker variant of the color by reducing the RGB values proportionally.
    ///
    /// This property generates a color with a lower luminance than the original. If the original
    /// color is already very dark, it remains black. The method retains the hue and saturation while
    /// lowering brightness to create a darker shade.
    ///
    /// - Returns: A `Color` object that is darker than the original.
    public var darker: Color {
        let originalLuminance = luminance
        
        // Jeśli kolor jest prawie czarny, pozostaje czarny
        if originalLuminance < 0.01 {
            return Color(red: 0, green: 0, blue: 0)
        }
        
        let targetLuminance = originalLuminance * 0.5
        
        let rgba = ColorProperties.RGBA(self)
        
        let scaleFactor = targetLuminance / (originalLuminance != 0 ? originalLuminance : 1)
        
        let newRed = max(rgba.red * scaleFactor, 0.0)
        let newGreen = max(rgba.green * scaleFactor, 0.0)
        let newBlue = max(rgba.blue * scaleFactor, 0.0)
        
        return Color(red: newRed, green: newGreen, blue: newBlue, opacity: rgba.alpha)
    }

    /// Determines if the color is generally light or dark based on luminance.
    ///
    /// This computed property provides a quick way to evaluate if the color appears light (high luminance)
    /// or dark (low luminance), which can be useful for UI themes and contrast checks.
    ///
    /// - Returns: `true` if the color has a luminance greater than 0.5, indicating it is light; `false` otherwise.
    public var isLight: Bool {
        luminance > 0.5
    }
    
    /// Returns a color with high contrast to the original based on luminance.
    ///
    /// This property generates either a black or white color to achieve maximum contrast with
    /// the original color. This is helpful for setting text colors against background colors for readability.
    ///
    /// - Returns: `.black` if the color is light; `.white` if the color is dark.
    public var contrastingWithLuminance: Color {
        luminance > 0.5 ? .black : .white
    }
    
    /// Returns a color with a hue shifted by 180° to contrast with the original color's hue.
    ///
    /// This property creates a contrasting color by modifying the hue to its complementary color
    /// (by shifting 180°), which can provide a visually distinct alternative without altering
    /// brightness or saturation.
    ///
    /// - Returns: A `Color` object with a hue that contrasts with the original.
    public var contrastingHue: Color {
        hsba { hue, saturation, brightness, alpha in
            hue += .degrees(180)
        }
    }
    
    /// Provides the best contrasting color based on the original color's luminance and hue.
    ///
    /// This property dynamically chooses the most effective contrasting color for the original.
    /// If the luminance is moderate, a complementary hue is chosen. For very light or dark colors,
    /// it returns black or white based on luminance for maximum contrast.
    ///
    /// - Returns: Either `contrastingHue` if luminance is moderate, or `contrastingWithLuminance` for high contrast.
    public var bestContastingColor: Color {
        if (0.2..<0.5).contains(luminance) {
            contrastingHue
        } else {
            contrastingWithLuminance
        }
    }
    
    /// Applies a transformation to the RGB components of the color and returns a new `Color` object.
    ///
    /// This method allows you to modify the individual red, green, and blue components of the color.
    /// You can provide a custom transformation function to apply specific changes to these components.
    /// Optionally, you can maintain the original luminance of the color after the transformation.
    ///
    /// - Parameters:
    ///   - transformation: A closure that accepts three inout parameters (red, green, blue) as `Double` values,
    ///     allowing direct modification of each component within the range [0, 1].
    ///   - maintainLuminance: A Boolean flag indicating whether to maintain the original luminance
    ///     of the color after the transformation. Defaults to `false`. If set to `true`, the method
    ///     adjusts the color's RGB values to preserve the original brightness.
    ///
    /// - Returns: A new `Color` object with the modified RGB components, optionally corrected to maintain
    ///   the original luminance.
    public func rgba(
        _ transformation: (inout Double, inout Double, inout Double, inout Double) -> Void
        , maintainLuminance: Bool = false) -> Color {
        let rgba = ColorProperties.RGBA(self)
        var alphaComponent = rgba.alpha
        var (red, green, blue) = (rgba.red, rgba.green, rgba.blue)
        transformation(&red, &green, &blue, &alphaComponent)
        red = min(1, max(0, red))
        green = min(1, max(0, green))
        blue = min(1, max(0, blue))
        alphaComponent = min(1, max(0, alphaComponent))

        if maintainLuminance {
            let originalLuminance = luminance
            let newLuminance = Self.luminance(from: .init(red, green, blue))
            let correctionFactor = originalLuminance / newLuminance
            
            // corrected values, but still in the [0, 1] range
            red = min(1, max(0, red * correctionFactor))
            green = min(1, max(0, green * correctionFactor))
            blue = min(1, max(0, blue * correctionFactor))
        }
        return Color(red: red, green: green, blue: blue, opacity: alphaComponent)
    }
    
    /// Applies a transformation to the HSB (Hue, Saturation, Brightness) components of the color and returns a new `Color` object.
    ///
    /// This method enables you to adjust the hue, saturation, and brightness of the color by providing a custom
    /// transformation function. The hue is represented as an `Angle`, while saturation and brightness are `Double` values.
    ///
    /// - Parameter transformation: A closure that accepts three inout parameters:
    ///   - `hue` as an `Angle`, representing the color's hue angle,
    ///   - `saturation` as a `Double`, representing the saturation level in the range [0, 1],
    ///   - `brightness` as a `Double`, representing the brightness level in the range [0, 1].
    ///   The closure allows direct modification of these components.
    ///
    /// - Returns: A new `Color` object with the modified HSB components.
    ///
    /// Note: The hue angle is automatically normalized within the full circle (0° to 360°) after the transformation.
    public func hsba(_ transformation: (inout Angle, inout Double, inout Double, inout Double) -> Void) -> Color {
        let hsba = ColorProperties.HSBA(self)
        var alphaComponent = hsba.alpha
        var (hue, saturation, brightness) = (hsba.hue.normalized, hsba.saturation, hsba.brightness)
        transformation(&hue, &saturation, &brightness, &alphaComponent)
        hue = hue.normalized
        let transformedColor = Color(hue: hue, saturation: saturation, brightness: brightness, alpha: alphaComponent)
        var rgba = ColorProperties.RGBA(transformedColor)
        rgba.red = max(0, min(1, rgba.red))
        rgba.green = max(0, min(1, rgba.green))
        rgba.blue = max(0, min(1, rgba.blue))
        rgba.alpha = max(0, min(1, rgba.alpha))
        return Color(red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension Color {
    private static func luminance(from rgba: ColorProperties.RGBA) -> CGFloat {
        return 0.299 * rgba.red + 0.587 * rgba.green + 0.114 * rgba.blue
    }
}

fileprivate extension Angle {
    var normalized: Angle {
        Angle(degrees: degrees.truncatingRemainder(dividingBy: 360))
    }
}

