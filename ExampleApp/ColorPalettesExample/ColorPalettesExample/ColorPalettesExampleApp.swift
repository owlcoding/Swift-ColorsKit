import SwiftUI

@main
struct ColorPalettesExampleApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}

struct AppView: View {
    var body: some View {
        TabView {
            PalettesView(viewModel: .init(), inputColors: Color.AnalogousPaletteIterator(color: .yellow).map{ $0.opacity(0.5) })
                .tabItem {
                    Label("Palettes, but from analogus colors of yellow and opacity 0,5", systemImage: "swatchpalette")
                }

            PalettesView(viewModel: .init())
                .tabItem {
                    Label("Palettes", systemImage: "swatchpalette.fill")
                }
            PalettesView(viewModel: .init(), inputColors: Color.AnalogousPaletteIterator(color: .yellow).map{ $0 })
                .tabItem {
                    Label("Palettes, but from analogus colors of yellow", systemImage: "swatchpalette")
                }
        }
    }
}

#Preview {
    AppView()
}
