//
//  Extensions.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 26/09/2020.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertControllerWithParamsByDefault(titleAlert: String, messageAlert: String, titleAction: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        let action = UIAlertAction(title: titleAction, style: .default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertControllerWithParams(titleAlert: String, messageAlert: String, actions: [UIAlertAction]){
        let alertController = UIAlertController(title: titleAlert, message: messageAlert, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
