//
//  File.swift
//  quick-cards
//
//  Created by Abby Smith on 7/12/18.
//  Copyright © 2018 Abby Smith. All rights reserved.
//

import UIKit

protocol PopUpPresentationController {
    var gesture: UIGestureRecognizer? { get set }
    var popUp: PopUpController? { get set }
    func dismissPopUp()
}

class PopUpController {
    
    var popUpController: UIViewController
    var dimmerView: UIView?
    var presentationController: PopUpPresentationController?
    
    init(popUpView: UIViewController) {
        self.popUpController = popUpView
    }
    
    func presentPopUp(on controller: PopUpPresentationController) {
        self.presentationController = controller
        guard let controller = controller as? UIViewController else { return }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        dimmerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        guard let dimmerView = dimmerView else { return }
        dimmerView.backgroundColor = .black
        dimmerView.alpha = 0
        
        
        popUpController.view.bounds.size = popUpController.view.systemLayoutSizeFitting(CGSize(width: width/1.25, height: height/3))
        popUpController.view.layer.cornerRadius = 10
        popUpController.view.layer.shadowOffset = CGSize(width: 0, height: 11)
        popUpController.view.layer.shadowOpacity = 0.15
        popUpController.view.layer.shadowRadius = 13
        popUpController.view.center.y = height + popUpController.view.bounds.height/2
        
        controller.view.addSubview(dimmerView)
        controller.view.addSubview(popUpController.view)
        controller.addChildViewController(popUpController)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            controller.navigationController?.navigationBar.backgroundColor = .black
            dimmerView.alpha = 0.25
            self.popUpController.view.center = controller.view.center
        }, completion: nil)
    }
    
    func dismissSubviews() {
        //dismiss subviews here
        guard let controller = presentationController as? UIViewController, let dimmerView = dimmerView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            controller.navigationController?.navigationBar.backgroundColor = .white
            dimmerView.alpha = 0
            self.popUpController.view.alpha = 0
        }) { (completion) in
            dimmerView.removeFromSuperview()
            self.popUpController.view.removeFromSuperview()
            self.popUpController.removeFromParentViewController()
        }
    }
    
    
}
