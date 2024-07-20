//
//  AppSpecificKeyboardDemo.swift
//  HelloKeyboardDemo
//
//  Created by Itsuki on 2024/07/20.
//


import SwiftUI

struct AppSpecificKeyboardDemo: View {
    @State private var input: String = "➤➤"
    @FocusState private var inputFocused
    
    @State private var textFieldRect: CGRect = .zero
    private let keyboardHeight: CGFloat = 300.0
    var body: some View {
        VStack(spacing: 20) {
            Text("input: \(input)")
                .padding(.horizontal, 16)
            
            CustomKeyboardTextfield(input: $input, keyboardHeight: keyboardHeight)
                .focused($inputFocused)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.yellow.opacity(0.3))
                )
                .overlay(content: {
                    GeometryReader { geometry in
                        DispatchQueue.main.async {
                            self.textFieldRect = geometry.frame(in: .global)
                        }
                        return Color.clear
                    }
                })
                .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .contentShape(Rectangle())
        .onAppear {
            inputFocused = true
        }
        .onTapGesture(coordinateSpace: .global) { location in
            if !textFieldRect.contains(location) {
                inputFocused = false
            }
        }

    }
}


fileprivate struct CustomKeyboardTextfield: UIViewRepresentable {
    
    @Binding var input: String
    var keyboardHeight: CGFloat

    func makeUIView(context: Context) -> UITextField {
        
        let textField = UITextField()

        textField.text = input
        textField.font = .systemFont(ofSize: 12)
        textField.delegate = context.coordinator
        // required so that the textfield height is not filling up the entire screen
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        
        let AnimalKeyboardViewController = UIHostingController(
            rootView: AnimalKeyboardView(
                insertText: { text in
                    textField.text = "\(textField.text ?? "")\(text)"
                },
                deleteText: {
                    guard let text = textField.text else {
                        textField.text = ""
                        return
                    }
                    if text.count > 0 {
                        textField.text = String(text.prefix(text.count - 1))
                    } else {
                        textField.text = ""
                    }
                },
                keyboardHeight: keyboardHeight
            ))
        
        let animalKeyboardView = AnimalKeyboardViewController.view!
        animalKeyboardView.translatesAutoresizingMaskIntoConstraints = false

        
        let inputView = UIInputView()
        inputView.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: keyboardHeight))

        inputView.addSubview(animalKeyboardView)
        
        NSLayoutConstraint.activate([
            animalKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
            animalKeyboardView.widthAnchor.constraint(equalToConstant: inputView.frame.width)
        ])

        textField.inputView = inputView
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {}
}



fileprivate extension CustomKeyboardTextfield {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomKeyboardTextfield

        init(_ control: CustomKeyboardTextfield) {
            self.parent = control
            super.init()
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let text = textField.text else { return }
            parent.input = text
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    }
}
