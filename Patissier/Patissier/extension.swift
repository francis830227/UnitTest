//
//  extension.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/6/22.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
           // DispatchQueue.main.async {() -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {() -> Void in
                self.image = image
                }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UILabel {
    func addCharactersSpacing( spacing: CGFloat, text: String ) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute( NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text.characters.count ))
        self.attributedText = attributedString
    }
}

extension UILabel {
    func addTextSpacing() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSKernAttributeName, value: 0.1, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIButton {
    func addTextSpacing(spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension CAGradientLayer {

    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
    }

    func creatGradientImage() -> UIImage? {

        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }

}

extension UINavigationBar {

    func setGradientBackground(colors: [UIColor]) {

        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)

        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}

// Color palette

extension UIColor {
    class var asiSandBrown: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 150.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }

    class var asiBrownish: UIColor {
        return UIColor(red: 160.0 / 255.0, green: 98.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkSalmon: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 113.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkSand: UIColor {
        return UIColor(red: 166.0 / 255.0, green: 145.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleTwo: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleGold: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }

    class var asiDenimBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }

    class var asiCoolGrey: UIColor {
        return UIColor(red: 171.0 / 255.0, green: 179.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
    }

    class var asiPale: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 239.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }

    class var asiDustyOrange: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 96.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }

    class var asiSlate: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 87.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkBlueGrey: UIColor {
        return UIColor(red: 8.0 / 255.0, green: 20.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }

    class var asiGreyish: UIColor {
        return UIColor(white: 178.0 / 255.0, alpha: 1.0)
    }

    class var asiCoolGreyTwo: UIColor {
        return UIColor(red: 165.0 / 255.0, green: 170.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkishBlue: UIColor {
        return UIColor(red: 3.0 / 255.0, green: 63.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    }

    class var asiSeaBlue: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 107.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }

    class var asiCharcoalGrey: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 1.0)
    }
}

// Text styles

extension UIFont {
    class func asiTextStyle3Font() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 80.0)
    }

    class func asiTextStyleFont() -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: 20.0)
    }

    class func asiTextStyle5Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func asiTextStyle2Font() -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: 14.0)
    }

    class func asiTextStyle4Font() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)
    }

    class func asiTextStyle6Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }
}
