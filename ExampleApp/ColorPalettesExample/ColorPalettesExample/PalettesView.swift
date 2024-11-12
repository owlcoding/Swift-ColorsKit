import SwiftUI
import UIKit
import ColorsKit

protocol Palette: IteratorProtocol<Color>, Sequence<Color> {
    init(color: Color, allowBrightnessChange: Bool)
    
    static var paletteName: String { get }
}

extension Palette {
    var iterator: Iterator {
        return self.makeIterator()
    }
}


extension Color.AnalogousPaletteIterator: Palette {
    static var paletteName = "Analogous"
}
extension Color.SplitComplementaryPaletteIterator: Palette {
    static var paletteName = "SplitComplementary"
}
extension Color.TetradicPaletteIterator: Palette {
    static var paletteName = "Tetradic"
}

extension Color {
    var rgbDescription: String {
        let rgba = ColorProperties.RGBA(self)
        let red = rgba.red.formatted(.number.precision(.significantDigits(2)))
        let green = rgba.green.formatted(.number.precision(.significantDigits(2)))
        let blue = rgba.blue.formatted(.number.precision(.significantDigits(2)))
        let alpha = rgba.alpha.formatted(.number.precision(.significantDigits(2)))
        
        return "\(red), \(green), \(blue), \(alpha)"
    }
}

extension Collection {
    func inserting(_ newElement: Element, at index: Int) -> [Element] {
        var result = Array(self)
        result.insert(newElement, at: index)
        return result
    }
}

@Observable class PaletteViewModel {
    private(set) var selectedColor: Color?
    private var paletteTypes: [any Palette.Type] = [Color.AnalogousPaletteIterator.self, Color.SplitComplementaryPaletteIterator.self, Color.TetradicPaletteIterator.self]
    var paletteDescriptions = ["Analogous", "Split Complementary", "Tetradic"]
    var paletteColorsForAllPaletteType: [(String, [Color])] = []
        
    init(selectedColor: Color? = nil) {
        self.selectedColor = selectedColor
    }
    
    private func generateColors(for paletteType: any Palette.Type) -> [Color] {
        guard let selectedColor = selectedColor else { return [] }
        return paletteType.init(color: selectedColor, allowBrightnessChange: true).map { $0 }.inserting(selectedColor, at: 0)
    }
    
    func onSelectedColorChange(_ color: Color) {
        self.selectedColor = color
        self.paletteColorsForAllPaletteType = paletteTypes.enumerated().map {
            (paletteDescriptions[$0.offset], generateColors(for: $0.element)) }
    }
    
    func onLongPress(_ color: Color) {
        // add color to the pasteboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = color.description
        pasteboard.color = UIColor(color)
    }
    
    func onLongPressHeader(_ colors: [Color]) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = colors.map { $0.description }.joined(separator: ", ")
        pasteboard.colors = colors.map(UIColor.init)
    }
}

struct PalettesView: View {
    @State var viewModel: PaletteViewModel
    
    var inputColors = [UIColor.systemRed, .systemGray, .systemGreen, .systemBlue, .systemPurple, .systemPink, .systemOrange, .systemYellow, .black, .white, .systemBrown, .systemTeal, .systemIndigo].compactMap { Color.init(uiColor: $0) }
    
    func colorSquare(color: Color) -> some View {
        Rectangle()
            .fill(color)
            .stroke(Color.primary)
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: "xmark")
                    .foregroundStyle(viewModel.selectedColor?.bestContastingColor ?? .clear)
                    .opacity(color == viewModel.selectedColor ? 1 : 0)
            )
    }
    
    func gradientForColors(_ colors: [Color]) -> LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
    }
    
    func colorStrips(_ colors: [Color]) -> some View {
        HStack(spacing: 0) {
            ForEach(colors, id: \.self) { color in
                color
                    .overlay(
                        Text(color.rgbDescription)
                            .foregroundColor(color.contrastingWithLuminance)
                            .font(.system(size: 8))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    )
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                viewModel.onLongPress(color)
                            }
                    )
            }
        }
    }
    
    var body: some View {
        VStack {
            Section("Select a base color") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
                    ForEach(inputColors, id: \.self) { color in
                        Button(action: { viewModel.onSelectedColorChange(color) }) {
                            colorSquare(color: color)
                        }
                    }
                }
                .padding()
                .background ( viewModel.selectedColor.opacity(0.4) )
            }
            
            Text("Long press on a color below to copy it to the pasteboard")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(viewModel.paletteColorsForAllPaletteType, id: \.0) { colors in
                VStack {
                    Text(colors.0)
                        .font(.headline)
                        .gesture(
                            LongPressGesture()
                                .onEnded { _ in
                                    viewModel.onLongPressHeader(colors.1)
                                }
                            )
                    colorStrips(colors.1)
                }

            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PalettesView(viewModel: .init())
}
