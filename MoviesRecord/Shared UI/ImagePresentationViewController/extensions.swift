//
//  extensions.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 19/05/2022.
//

import UIKit

extension UIAlertController {
    static func imageAuthNotGrantedAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: NSLocalizedString("can't save image, please grant permission from Settings.", comment: "Image saving rejected due to access permission is not yet granted"), message: nil, preferredStyle: .alert)
        let permissionsSettingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(permissionsSettingsAction)
        alertController.preferredAction = cancelAction
        return alertController
    }
}
