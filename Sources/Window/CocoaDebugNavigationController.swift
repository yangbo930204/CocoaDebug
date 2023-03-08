//
//  CocoaDebug
//  liman
//
//  Created by liman 02/02/2023.
//  Copyright © 2023 liman. All rights reserved.
//

import UIKit

class CocoaDebugNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false //liman
        
        navigationBar.tintColor = Color.mainGreen
        navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20),
                                             .foregroundColor: Color.mainGreen]
        
        let selector = #selector(CocoaDebugNavigationController.exit)
        
        let image = UIImage(named: "_icon_file_type_close", in: Bundle(for: CocoaDebugNavigationController.self), compatibleWith: nil)
        let leftItem = UIBarButtonItem(image: image,
                                       style: .done, target: self, action: selector)
        leftItem.tintColor = Color.mainGreen
        topViewController?.navigationItem.leftBarButtonItem = leftItem
        let backgroundImage = UIColor.black.getImageWithColor(CGSize.zero)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = navigationBar.titleTextAttributes!
            appearance.backgroundColor = UIColor.black
            appearance.backgroundImage = backgroundImage
            appearance.backgroundEffect = nil
            appearance.shadowColor = UIColor.clear
            appearance.shadowImage = UIImage()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.titleTextAttributes = navigationBar.titleTextAttributes!
            navigationBar.shadowImage = UIImage()
        }
        navigationBar.setBackgroundImage(backgroundImage, for: .default)
    }
    
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}
