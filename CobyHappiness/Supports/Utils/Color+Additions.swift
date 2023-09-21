//
//  Color+Additions.swift
//  CobyHappiness
//
//  Created by COBY_PRO on 2023/09/21.
//

import SwiftUI

extension Color {
    @nonobjc static var imageDefault: Color {
        return Color(uiColor: .init(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1.0))
    }

    @nonobjc static var imagePlaceholder: Color {
        return Color(uiColor: .init(white: 222.0 / 255.0, alpha: 1.0))
    }

    @nonobjc static var imageBlackout: Color {
        return Color(uiColor: .init(white: 0.0, alpha: 0.64))
    }

    @nonobjc static var pureBlack: Color {
        return Color(uiColor: .init(white: 0.0, alpha: 1.0))
    }

    @nonobjc static var backgroundPrimary: Color {
        return Color(uiColor: .init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 13.0 / 255.0, green: 14.0 / 255.0, blue: 19.0 / 255.0, alpha: 1.0)
            default: return UIColor(white: 1.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var backgroundSecondary: Color {
        return Color(uiColor: .init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 23.0 / 255.0, green: 25.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 243.0 / 255.0, green: 245.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var backgroundBlue: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 25.0 / 255.0, green: 32.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var backgroundOrange: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 42.0 / 255.0, green: 38.0 / 255.0, blue: 31.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 1.0, green: 251.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var backgroundRed: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 40.0 / 255.0, green: 24.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 254.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var backgroundGreen: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 27.0 / 255.0, green: 40.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 247.0 / 255.0, green: 252.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var backgroundGray: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 42.0 / 255.0, green: 43.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
            default: return UIColor(white: 235.0 / 255.0, alpha: 1.0)
            }
        })
    }
    
    @nonobjc static var backgroundLightGray: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 32.0 / 255.0, green: 33.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
            default: return UIColor(white: 245.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var grayscale100: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 1.0, alpha: 0.96)
            default: return UIColor(white: 33.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var grayscale200: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 1.0, alpha: 0.72)
            default: return UIColor(white: 82.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var grayscale300: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 1.0, alpha: 0.48)
            default: return UIColor(white: 114.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var grayscale400: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 1.0, alpha: 0.24)
            default: return UIColor(white: 183.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var grayscaleR100: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 0.0, alpha: 0.9)
            default: return UIColor(white: 1.0, alpha: 0.96)
            }
        })
    }

    @nonobjc static var grayscaleR200: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 0.0, alpha: 0.7)
            default: return UIColor(white: 1.0, alpha: 0.72)
            }
        })
    }

    @nonobjc static var grayscaleR300: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 0.0, alpha: 0.4)
            default: return UIColor(white: 1.0, alpha: 0.48)
            }
        })
    }

    @nonobjc static var grayscaleR400: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 0.0, alpha: 0.12)
            default: return UIColor(white: 1.0, alpha: 0.12)
            }
        })
    }

    @nonobjc static var blueBase: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 40.0 / 255.0, green: 83.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 46.0 / 255.0, green: 88.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var blueD60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 16.0 / 255.0, green: 33.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 18.0 / 255.0, green: 35.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var blueD40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 24.0 / 255.0, green: 50.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 28.0 / 255.0, green: 53.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var blueD20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 32.0 / 255.0, green: 66.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 37.0 / 255.0, green: 70.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var blueL20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 83.0 / 255.0, green: 117.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 88.0 / 255.0, green: 121.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var blueL40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 126.0 / 255.0, green: 152.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 88.0 / 255.0, green: 121.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var blueL60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 169.0 / 255.0, green: 186.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 88.0 / 255.0, green: 121.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeBase: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 1.0, green: 182.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 1.0, green: 166.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeD60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 102.0 / 255.0, green: 73.0 / 255.0, blue: 24.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 102.0 / 255.0, green: 66.0 / 255.0, blue: 7.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeD40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 153.0 / 255.0, green: 109.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 153.0 / 255.0, green: 100.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeD20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 204.0 / 255.0, green: 146.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 204.0 / 255.0, green: 133.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeL20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 1.0, green: 197.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 1.0, green: 184.0 / 255.0, blue: 65.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeL40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 1.0, green: 211.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 1.0, green: 202.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var orangeL60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 1.0, green: 226.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 1.0, green: 219.0 / 255.0, blue: 160.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redBase: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 239.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 225.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redD60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 96.0 / 255.0, green: 4.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 90.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redD40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 143.0 / 255.0, green: 6.0 / 255.0, blue: 6.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 135.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redD20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 191.0 / 255.0, green: 8.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 180.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redL20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 242.0 / 255.0, green: 59.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 231.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redL40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 245.0 / 255.0, green: 108.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 237.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var redL60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 249.0 / 255.0, green: 157.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 243.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenBase: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 78.0 / 255.0, green: 212.0 / 255.0, blue: 29.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 57.0 / 255.0, green: 180.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenD60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 31.0 / 255.0, green: 85.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 23.0 / 255.0, green: 72.0 / 255.0, blue: 5.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenD40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 46.0 / 255.0, green: 127.0 / 255.0, blue: 17.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 34.0 / 255.0, green: 108.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenD20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 62.0 / 255.0, green: 170.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 46.0 / 255.0, green: 144.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenL20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 113.0 / 255.0, green: 221.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 97.0 / 255.0, green: 195.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenL40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 148.0 / 255.0, green: 229.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 136.0 / 255.0, green: 210.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var greenL60: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 184.0 / 255.0, green: 238.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 176.0 / 255.0, green: 225.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
            }
        })
    }
    
    @nonobjc static var purpleBase: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 207.0 / 255.0, green: 170.0 / 255.0, blue: 1.0, alpha: 1.0)
            default: return UIColor(red: 207.0 / 255.0, green: 170.0 / 255.0, blue: 1.0, alpha: 1.0)
            }
        })
    }
    
    @nonobjc static var purpleL20: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 171.0 / 255.0, green: 188.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 171.0 / 255.0, green: 188.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
            }
        })
    }
    
    @nonobjc static var purpleL40: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 85.0 / 255.0, green: 201.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
            default: return UIColor(red: 85.0 / 255.0, green: 201.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var borderDefault: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 71.0 / 255.0, green: 72.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
            default: return UIColor(white: 222.0 / 255.0, alpha: 1.0)
            }
        })
    }

    @nonobjc static var borderDisabled: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 42.0 / 255.0, green: 43.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
            default: return UIColor(white: 239.0 / 255.0, alpha: 1.0)
            }
        })
    }
}
