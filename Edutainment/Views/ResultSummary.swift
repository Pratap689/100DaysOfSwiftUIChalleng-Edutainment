//
//  ResultSummary.swift
//  Edutainment
//
//  Created by netset on 07/03/22.
//

import SwiftUI

struct ResultSummary: View {
    @State var usersAnswers: [QuestionModel]? = UserAnswerSummary.dummyAnswerData()
    @State var resultSummary: ResultSummaryModel?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .leading) {
            BackButton(imageName: "xmark") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.primary)
            .padding()
            List(usersAnswers!, id: \.id) { answer in
                SummaryCell(answer: answer)
                    .listRowBackground(Color.primary)
            }
            Spacer()
                .listStyle(.insetGrouped)
            ZStack {
                Color.black
                    .clipShape(CustomCoreners(radius: 30, corners: [.topLeft, .topRight]))
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity)
                resultView
            }
            .frame(height: AppInfo.sceenHeight * 0.35)
        }
    }
    
    fileprivate func extractedFunc(_ index: Int) -> some View {
        return resultDetailView(index)
    }
    
    var resultView: some View {
        VStack(spacing: -15) {
            Spacer()
            Capsule()
                .fill(Color.init(UIColor.init(r: 40, g: 40, b: 43, a: 1)))
                .frame(height: 55)
                .shadow(color: .black, radius: 3, x: -2, y: -5)
                .padding()
                .overlay {
                    TextView(properties: TextProperties(font: .largeTitle, fontWeight: .bold, title: "Result", color: .white))
                        .shadow(color: .clear, radius: 5, x: 1, y: 1)
                }
                .shadow(color: .white, radius: 1, x: 0, y: 0)
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.init(UIColor.init(r: 27, g: 18, b: 18, a: 1)))
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(colors: [Color.init(UIColor.init(r: 4, g: 1, b: 1, a: 0.3)), Color.init(UIColor.init(r: 2, g: 1, b: 4, a: 0.7))], startPoint: .topTrailing, endPoint: .bottomLeading)
                        )
                        .frame(maxWidth: .infinity)
                        .padding([.horizontal, .vertical], 30)
                        .overlay {
                            VStack(alignment: .leading) {
                                ForEach(0..<5) { index in
                                    extractedFunc(index)
                                }
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 45)
                        }
                        .shadow(color: .clear, radius: 10, x: 0, y: 0)
                }
                .shadow(color: .primary, radius: 5, x: 0, y: 0)
        }
    }
    
    func resultDetailView(_ index: Int) -> some View {
        var text = ""
        switch index {
        case 0: text = "Total Questions You Attempt - \(resultSummary?.totalQuestionsAttempt ?? 0)/\(resultSummary?.totalQuestions ?? 0)"
        case 1: text = "Correct Answers - \(resultSummary?.correctQuestions ?? 0)"
        case 2: text = "Incorrect Answers - \(resultSummary?.incorrectQuestions ?? 0)"
        case 3: text = "Un-Answered - \(resultSummary?.unansweredQues ?? 0)"
        case 4: text = "Total Score You Got  - \(resultSummary?.totalScoreObtained ?? 0)/\(resultSummary?.totalScore ?? 0)"
        default: break
        }
         return Text(text)
            .fontWeight(.semibold)
            .padding(.vertical, 1)
    }
}

struct ResultSummary_Previews: PreviewProvider {
    static var previews: some View {
        ResultSummary()
            .preferredColorScheme(.light)
    }
}
