//
//  AnimalKeyboardView.swift
//  HelloKeyboardDemo
//
//  Created by Itsuki on 2024/07/20.
//

import SwiftUI

struct AnimalKeyboardView: View {
    var insertText: (String) -> Void
    var deleteText: () -> Void
    
    let keyboardHeight: CGFloat
    
    var needsInputModeSwitchKey: Bool = false
    var nextKeyboardAction: Selector? = nil
    
    var backgroundColor: Color = .yellow.opacity(0.3)


    private let animalList = [
        "🐱",
        "🐷",
        "🦫",
        "🦭",
        "🐼",
        "🐮",
        "🐰",
        "🐭",
        "🐘",
        "🐹",
        "🦊",
        "🐬"
    ]
    private let column = GridItem.init(.adaptive(minimum: 56, maximum: 56), spacing: 32)
    private let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    private let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)

    var body: some View {
        VStack(spacing: 24) {
            LazyVGrid(columns: [column], spacing: 24, content: {
                ForEach(animalList, id: \.self) { animal in
                    Button(action: {
                        insertText(animal)
                    }, label: {
                        Text(animal)
                            .font(.system(size: 32))
                            .padding(.all, 8)
                            .background( RoundedRectangle(cornerRadius: 8)
                                .fill(.white.opacity(0.8))
                                .stroke(darkEnd, style: .init(lineWidth: 1))
                                .shadow(color: darkStart, radius: 1, x: 1, y: 1)
                                .shadow(color: darkEnd, radius: 1, x: -1, y: -1)
                            
                            )
                    })
                    
                }
            })
            
            HStack(spacing: 40) {
                if needsInputModeSwitchKey &&  nextKeyboardAction != nil{
                    Button(action: {}, label: {
                        Image(systemName: "globe")
                            .foregroundStyle(.black.opacity(0.8))
                            .padding(.all, 8)
                            .overlay(NextKeyboardButtonOverlay(action: nextKeyboardAction!))
                            .background( RoundedRectangle(cornerRadius: 8)
                                .fill(.white.opacity(0.8))
                                .stroke(darkEnd, style: .init(lineWidth: 1))
                                .shadow(color: darkStart, radius: 1, x: 1, y: 1)
                                .shadow(color: darkEnd, radius: 1, x: -1, y: -1)
                            )
                    })
                }
                
                Button(action: {
                    insertText(" ")
                }, label: {
                    Text("space")
                        .foregroundStyle(.black.opacity(0.8))
                        .padding(.all, 8)
                        .frame(maxWidth: .infinity)
                        .background( RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.8))
                            .stroke(darkEnd, style: .init(lineWidth: 1))
                            .shadow(color: darkStart, radius: 1, x: 1, y: 1)
                            .shadow(color: darkEnd, radius: 1, x: -1, y: -1)
                        )
                })

                
                Button(action: {
                    deleteText()
                }, label: {
                    Text("delete")
                        .foregroundStyle(.red.opacity(0.8))
                        .padding(.all, 8)
                        .frame(maxWidth: .infinity)
                        .background( RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.8))
                            .stroke(darkEnd, style: .init(lineWidth: 1))
                            .shadow(color: darkStart, radius: 1, x: 1, y: 1)
                            .shadow(color: darkEnd, radius: 1, x: -1, y: -1)
                        )
                })

            }
            .padding(.horizontal, 40)

        }
        .padding(.top, 32)
        .padding(.bottom, 16)
        .frame(height: keyboardHeight)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)

    }
}

struct NextKeyboardButtonOverlay: UIViewRepresentable {
    let action: Selector

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()
        button.addTarget(nil, action: action, for: .allTouchEvents)
        return button
    }
    func updateUIView(_ button: UIButton, context: Context) {}
}


#Preview {
    AnimalKeyboardView(insertText: {_ in}, deleteText: {}, keyboardHeight: 300, needsInputModeSwitchKey: true)
}
