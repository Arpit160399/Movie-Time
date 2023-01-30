//
//  ErrorPresnterHelper.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//
import UIKit
import Combine
extension UIViewController {
    
    fileprivate func createAlert(_ error: Error) -> UIAlertController {
        var message = StringResource.unknownErrorMessage
        if let localError = error as? LocalError {
            message = localError.localizedDescription
        }
        let alert = UIAlertController(title: StringResource.errorTitle,
                                      message: message, preferredStyle: .alert)
        return alert
    }
    
    func present(error: Error)  {
        let alert = createAlert(error)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func present<T: Subject<Void,Never>>(error: Error,_ event: T)  {
        let alert = createAlert(error)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.dismiss(animated: true) {
                event.send()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

