//
//  ConstantsView.swift
//  Edutainment
//
//  Created by netset on 04/03/22.
//

import Foundation
import SwiftUI

typealias CompletionHandler = (_ success: Bool) -> Void

struct ButtonProperties {
    let bgColor: Color
    let titleColor: Color
    let title: String
    var shadowColor: Color = .black
    var shadowProperties = (x: 0.0, y: 0.0, color: Color.gray, radius: 1.0)
}

struct TextProperties {
    var font: Font
    var fontWeight: Font.Weight
    var title: String
    var color: Color
}

struct ButtonView: View {
    let properties: ButtonProperties
    var callBackClouser: ()->()?
    var body: some View {
        Button {
            callBackClouser()
        } label: {
            Text(properties.title)
        }
        .font(.headline)
        .foregroundColor(properties.titleColor)
        .frame(maxWidth: .infinity, maxHeight: 35)
        .padding()
        .background(properties.bgColor)
        .cornerRadius(10)
        .shadow(color: properties.shadowProperties.color, radius: properties.shadowProperties.radius, x: properties.shadowProperties.x, y: properties.shadowProperties.y)
    }
}

struct TextView: View {
    let properties: TextProperties
    var body: some View {
        Text(properties.title)
            .font(properties.font)
            .fontWeight(properties.fontWeight)
            .foregroundColor(properties.color)
    }
}

enum BackgroundColors {
    static var userSettingBGColor: some View {
        LinearGradient(stops: [Gradient.Stop(color: .purple.opacity(0.4), location: 0.4), Gradient.Stop(color: .white.opacity(0.9), location: 0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .modifier(IgnoreSafeArea())
    }
    
    static var trueFalseColor: some View {
        RadialGradient(colors: [.blue, Color(hue: 0.7, saturation: 0.6, brightness: 1, opacity: 0.4)], center: .topTrailing, startRadius: 50, endRadius: 600)
            .modifier(IgnoreSafeArea())
    }
    
    static var resultViewBGColor: some View {
        LinearGradient(colors: [.orange, .red], startPoint: .bottomLeading, endPoint: .topTrailing)
            .modifier(IgnoreSafeArea())
    }

    static var fillIntheBalance: some View {
        Color.init(UIColor.init(r: 16, g: 12, b: 8, a: 1)).ignoresSafeArea()
    }
}

struct QuestionTextView: View {
    var question: String
    var body: some View {
        Text(question)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(color: .clear, radius: 0, x: 0, y: 0)
    }
}

struct IgnoreSafeArea: ViewModifier {
    func body(content: Content) -> some View {
        content.ignoresSafeArea()
    }
}

struct DismissView {
    @Environment(\.presentationMode) static var presentationMode
}

struct AppInfo {
    static let sceenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let appName = "Table Game"
}


func showAlert(showResultsInEnd: Bool = false, callback: @escaping (String)->()?) ->  Alert {
    if showResultsInEnd {
        return Alert(title: Text("Game Over"), message: Text("Game has been ended. Do you want to see your score summary?"), primaryButton: .default(Text("Yes"), action: {
            callback("Yes")
        }), secondaryButton: .default(Text("Go Back"), action: {
            callback("Go Back")
        }))
        
    } else {
        return  Alert(title: Text("Game Over"), message: Text("Game has been ended. Kindly go back to the setting screen"), dismissButton: .default(Text("Go Back"), action: {
            callback("Go Back")
        }))
    }
}

class UserAnswerSummary {
    var userAnsArray = [QuestionModel]()
    
    func storeUserAnswers(answer: QuestionModel) {
        userAnsArray.append(answer)
    }
    
    static func dummyAnswerData() -> [QuestionModel] {
        return [QuestionModel(question: "Ques1", answer: 23, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques2", answer: 24, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques3", answer: 25, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques4", answer: 26, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques5", answer: 27, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques6", answer: 28, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques1", answer: 29, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques7", answer: 30, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques8", answer: 31, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques9", answer: 32, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques10", answer: 33, answerType: .Incorrect, multipleQuesOptions: nil),
                QuestionModel(question: "Ques12", answer: 34, answerType: .Incorrect, multipleQuesOptions: nil)
        ]
    }
}

//Navigation Bar Buttons
struct BackButton: View {
    var imageName: String = ""
    var callBack: ()->()?
    var body: some View {
        Button {
            callBack()
        } label: {
            Image(systemName: imageName)
                .resizable()
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
        }
    }
}

struct ScoreView: View {
    var totalScore: Int = 0
    @Binding var yourScore: Int
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(.black.opacity(0.5))
            .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: 4)
            .frame(idealWidth: 150, maxWidth: .infinity, minHeight: 35)
            .overlay {
                Text("Your score: \(yourScore)/\(totalScore)")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .padding()
    }
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
