//
//  KeyboardViewController.swift
//  HelloKeyboard
//
//  Created by Itsuki on 2024/07/15.
//

import SwiftUI

class KeyboardViewController: UIInputViewController {

    private let keyboardHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let animalKeyboardViewController = UIHostingController(
            rootView: AnimalKeyboardView(
                insertText: { [weak self] text in
                    guard let self else { return }
                    self.textDocumentProxy.insertText(text)

                },
                deleteText: { [weak self] in
                    guard let self,
                          self.textDocumentProxy.hasText else { return }

                    self.textDocumentProxy.deleteBackward()
                },
                keyboardHeight: keyboardHeight,
                needsInputModeSwitchKey: self.needsInputModeSwitchKey,
//                needsInputModeSwitchKey: true,
                nextKeyboardAction: #selector(self.handleInputModeList(from:with:)),
                backgroundColor: .clear
            ))
        
        let animalKeyboardView = animalKeyboardViewController.view!
        animalKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // default to white
        animalKeyboardViewController.view.backgroundColor = .clear

        
        self.addChild(animalKeyboardViewController)
        self.view.addSubview(animalKeyboardView)
        animalKeyboardViewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            animalKeyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
            animalKeyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            animalKeyboardView.rightAnchor.constraint(equalTo: view.rightAnchor),
            animalKeyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
