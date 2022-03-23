//
//  ResultView.swift
//  Edutainment
//
//  Created by netset on 04/03/22.
//

import SwiftUI

struct ResultView: View {
    var answer: QuestionModel?
    @Binding var dismiss: Bool
    var body: some View {
        ZStack {
            Color(.clear)
                .frame(width: AppInfo.screenWidth - 25, height: AppInfo.sceenHeight*0.4 - 25)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.8), .white.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 3)
                }
            VStack {
                HStack {
                    Button {
                        dismiss.toggle()
                    } label: {
                        Image(systemName: "multiply")
                            .resizable()
                            .renderingMode(.original)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 30)
                Image(answer?.answerType.rawValue ?? "")
                    .resizable()
                    .frame(width: 150, height: 150)
                AnswerView(textProperties: ResultTextProperties(title: answer?.answerType.rawValue ?? "", fontWeight: .bold, font: .largeTitle))
                AnswerView(textProperties: ResultTextProperties(title: "The Answer is - \(answer?.answer ?? "")", fontWeight: .bold, font: .title3))
                
            }
        }
    }
    
    struct AnswerView: View {
       fileprivate var textProperties: ResultTextProperties
        var body: some View {
            Text(textProperties.title)
                .font(textProperties.font)
                .fontWeight(textProperties.fontWeight)
                .foregroundColor(.primary)
                .padding()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(dismiss: .constant(false))
    }
}

fileprivate struct ResultTextProperties {
    let title: String
    let fontWeight: Font.Weight
    let font: Font
}
