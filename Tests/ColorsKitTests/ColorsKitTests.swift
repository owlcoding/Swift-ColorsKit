import SwiftUI
import Testing
import UIKit

@testable import ColorExtensions
@testable import ColorPalettes
@testable import ColorsKit

@Test
func testNonOpaqueColors() {
    let startColor = Color.red.opacity(0.5)

    let newColor = startColor.rgba { _, g, b, _ in
        g = 1
        b = 1
    }

    #expect(Color.ColorProperties.RGBA(newColor).alpha == 0.5)
    #expect(Color.ColorProperties.RGBA(newColor).red == 1)
    #expect(Color.ColorProperties.RGBA(newColor).green == 1)
    #expect(Color.ColorProperties.RGBA(newColor).blue == 1)
}

#if canImport(UIKit)
    @Test
    func testUIKitColors() {
        var uiColor = UIColor(cgColor: UIColor.red.cgColor.copy(alpha: 0.5)!)

        let color = Color(uiColor)

        let secondNewColor = color.rgba { _, g, b, _ in
            g = 1
            b = 1
        }

        #expect(Color.ColorProperties.RGBA(secondNewColor).alpha == 0.5)
        #expect(Color.ColorProperties.RGBA(secondNewColor).red == 1)
        #expect(Color.ColorProperties.RGBA(secondNewColor).green == 1)
        #expect(Color.ColorProperties.RGBA(secondNewColor).blue == 1)
        #expect(PlatformColor(secondNewColor).cgColor.alpha == 0.5)
    }
#endif

#if canImport(AppKit)
    @Test
    func testAppKitColors() {
        var nsColor = NSColor(cgColor: NSColor.red.cgColor.copy(alpha: 0.5)!)

        let color = Color(nsColor)

        let secondNewColor = color.rgba { _, g, b, _ in
            g = 1
            b = 1
        }

        #expect(Color.ColorProperties.RGBA(secondNewColor).alpha == 0.5)
        #expect(Color.ColorProperties.RGBA(secondNewColor).red == 1)
        #expect(Color.ColorProperties.RGBA(secondNewColor).green == 1)
        #expect(Color.ColorProperties.RGBA(secondNewColor).blue == 1)
        #expect(PlatformColor(secondNewColor).cgColor.alpha == 0.5)
    }
#endif

@Test
func checkIfAlphaModificationWorks() {
    let startColor = Color.red.opacity(0.5)

    let newColor = startColor.rgba { _, _, _, a in
        a = 1
    }

    #expect(Color.ColorProperties.RGBA(newColor).alpha == 1)

    let startColor2 = Color.green
    let newColor2 = startColor2.hsba { h, s, b, a in
        a = 0.5
        h += .degrees(90)
    }

    #expect(Color.ColorProperties.HSBA(newColor2).alpha == 0.5)

    var newColor3 = newColor
    newColor3.alpha = 0.75

    #expect(Color.ColorProperties.RGBA(newColor3).alpha == 0.75)

}
