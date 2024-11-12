# ColorsKit

ColorsKit is a Swift library providing extensions and color palettes to work with colors in a more versatile way. It includes modules for manipulating color properties (e.g., `luminance`, `lighter`, `darker`), generating various color palettes, and creating harmonious color schemes.

## Features

- **Color Manipulation**: Extensions for `Color` providing functionalities like `lighter`, `darker`, `luminance`, and contrast-based color.
- **Color Palettes**:
  - **Analogous Palette**: Generates colors similar in hue, which sit next to each other on the color wheel. This type of palette is commonly used to create **soft, harmonious color schemes** that are pleasing to the eye and provide a sense of unity in design. [Learn more about analogous colors on Wikipedia.](https://en.wikipedia.org/wiki/Analogous_colors)
  
  - **Split Complementary Palette**: Provides colors that are contrasting but less intense than direct complementary colors. This palette includes a base color and two adjacent colors from the opposite side of the color wheel, making it ideal for **balanced, contrasting color schemes** without being too harsh. [Read more about split-complementary colors on Wikipedia.](https://en.wikipedia.org/wiki/Complementary_colors#Split-complementary_colors)
  
  - **Tetradic Palette**: Generates a palette with colors spaced equally around the color wheel, forming a rectangle or square. This palette offers a rich, **diverse color scheme with multiple contrasting hues**, which can be challenging to balance but rewarding in dynamic designs. [Learn more about tetradic color schemes on Wikipedia.](https://en.wikipedia.org/wiki/Tetradic_colors)

- **Multi-Platform Support**: iOS, macOS, watchOS, tvOS, and visionOS compatible.
## Installation

To add ColorsKit to your project, use the Swift Package Manager. In Xcode, select **File > Swift Packages > Add Package Dependency...** and enter the repository URL.

## Usage

### Color Extensions

```swift
import SwiftUI
import ColorsKit

let color = Color.red
let lighterColor = color.lighter
let darkerColor = color.darker
let contrastColor = color.bestContastingColor
```

### Analogous Palette

```swift
import SwiftUI
import ColorsKit

let baseColor = Color.green
var analogousIterator = Color.AnalogousPaletteIterator(color: baseColor)

while let analogousColor = analogousIterator.next() {
    print("Analogous Color: \(analogousColor)")
}
```

### Split Complementary Palette

```swift
import SwiftUI
import ColorsKit

let baseColor = Color.blue
var splitComplementaryIterator = Color.SplitComplementaryPaletteIterator(color: baseColor)

while let splitComplementaryColor = splitComplementaryIterator.next() {
    print("Split Complementary Color: \(splitComplementaryColor)")
}
```

### Tetradic Palette

```swift
import SwiftUI
import ColorsKit

let baseColor = Color.red
var tetradicIterator = Color.TetradicPaletteIterator(color: baseColor)

while let tetradicColor = tetradicIterator.next() {
    print("Tetradic Color: \(tetradicColor)")
}
```

## Modules

## Modules

ColorsKit is divided into multiple modules, each designed to handle specific tasks related to color manipulation and palette generation:

- **ColorExtensions**: Provides core extensions and tools for manipulating color properties, such as adjusting brightness, generating contrasting colors, and calculating luminance. This module is focused on **color transformation and analysis**, allowing you to work with `Color` in a more flexible way. [Learn more about color manipulation on Wikipedia.](https://en.wikipedia.org/wiki/Color_theory#Tints_and_shades)
  
- **ColorPalettes**: Contains algorithms for generating different color palettes (Analogous, Split Complementary, Tetradic) based on a base color. This module is useful for **creating harmonious and visually appealing color schemes** for UI and design purposes. [Read more about color harmony on Wikipedia.](https://en.wikipedia.org/wiki/Color_theory#Color_harmonies)

Each module is designed to be reusable and modular, so you can incorporate only the parts you need in your project.
## Documentation

For more detailed documentation and examples, refer to the source code comments and generated documentation.

## Example Application

This repository includes a simple example application located in the `ExampleApp` directory. The application demonstrates the usage of various color manipulation features and color palettes provided by ColorsKit. You can find the application package at: `ExampleApp/Package.swift`. To open the example app, navigate to `ColorPalettesExample.xcodeproj` inside the `ColorPalettesExample` folder. The app is designed to give you a quick, hands-on overview of how to integrate ColorsKit into your own projects.

## Contributing

Feel free to open issues or submit pull requests if you have any suggestions or improvements.

## License

ColorsKit is licensed under the MIT License.

## Support

If you find this library helpful and would like to support its development, feel free to [buy me an apple 🍏](https://buymeacoffee.com/owlcoding). Every bit of support helps fuel future updates and enhancements!
