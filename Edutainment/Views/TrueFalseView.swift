//
//  TrueFalseView.swift
//  Edutainment
//
//  Created by netset on 02/03/22.
//

import SwiftUI

struct TrueFalseView: View {
    @EnvironmentObject var gameSetting: GameSetting
    @State private var quetionObject: [QuestionModel]?
    @State private var resultSummary: ResultSummaryModel? = ResultSummaryModel()
    @State private var showAnswerSheet: Bool = false
    @State private var questionIndex: Int = 0
    @State private var score: Int = 0
    @State private var showResultInTheEnd = false
    @State private var showSummary: Bool = false
    @State private var rotationEffect: Bool = false
    @State private var rotationAngle: Double = 0
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .center) {
            Image("Game")
                .resizable()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                QuestionView(question: "\(questionIndex + 1) - \(quetionObject?[questionIndex].question ?? "")")
                Spacer()
                bottomButtonView()
            }.padding()
            if gameSetting.showAnswerAfterEveryQue && showAnswerSheet { resultView }
        }
        .onAppear(perform: {
            //Uncomment this when You Run this app
            quetionObject = gameSetting.giveAnswerArr()
            resultSummary?.totalQuestions = gameSetting.numberOfQuestions
            resultSummary?.totalScore = gameSetting.totalMarks
        })
        .onDisappear(perform: {
            quetionObject = nil
        })
        .alert(isPresented: $showResultInTheEnd, content: {
            showAlert(showResultsInEnd: gameSetting.showResultsInEnd) { str in
                if str == "Go Back" {
                    return presentationMode.wrappedValue.dismiss()
                } else {
                    if gameSetting.showResultsInEnd {
                        showSummary.toggle()
                    }
                    return presentationMode.wrappedValue.dismiss()
                }
            }
        })
        .sheet(isPresented: $showSummary, onDismiss: {
            presentationMode.wrappedValue.dismiss()
        }, content: {
            ResultSummary(usersAnswers: quetionObject, resultSummary: resultSummary)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton(imageName: "arrow.backward.circle.fill") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                ScoreView(totalScore: gameSetting.totalMarks, yourScore: $score)
            }
        }
        .navigationBarTitle("True False Quetions")
        .navigationBarBackButtonHidden(true)
    }
    
    func bottomButtonView() -> some View {
        VStack {
            HStack {
                ButtonView(properties: ButtonProperties(bgColor: .green, titleColor: .white, title: "Correct")) {
                    resultSummary?.correctQuestions += 1
                    resultSummary?.totalScoreObtained += gameSetting.marksPerQue
                    score += gameSetting.marksPerQue
                    return handleButtonTap(.Correct)
                }
                ButtonView(properties: ButtonProperties(bgColor: .red, titleColor: .white, title: "Incorrect")) {
                    resultSummary?.incorrectQuestions += 1
                    return handleButtonTap(.Incorrect)
                }
            }
            ButtonView(properties: ButtonProperties(bgColor: .blue, titleColor: .white, title: "Skip")) {
                resultSummary?.unansweredQues += 1
                return handleButtonTap(.Skipped)
            }
        }
        .disabled(gameSetting.showAnswerAfterEveryQue ? showAnswerSheet: false)
        .padding()
        .background(.gray.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func gotoNextQue() {
        var index = questionIndex
        index += 1
        if (gameSetting.numberOfQuestions - 1) < index {
            showResultInTheEnd.toggle()
        } else {
            questionIndex = index
        }
    }
    
    private func handleButtonTap(_ answerType: AnswerType) {
        quetionObject?[questionIndex].answerType = answerType
        if !gameSetting.showAnswerAfterEveryQue {
            gotoNextQue()
        } else {
            withAnimation(.spring()) {
                showAnswerSheet.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.spring()) {
                        rotationAngle = 360
                    }
                }
            }
        }
        resultSummary?.totalQuestionsAttempt += 1
    }
    
    private var resultView: some View {
        ResultView(answer: quetionObject?[questionIndex], dismiss: $showAnswerSheet)
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
            .onDisappear {
                gotoNextQue()
            }
            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 1, y: 0, z: 0))
            .offset(y: -70)
    }
}

struct TrueFalseView_Previews: PreviewProvider {
    static var previews: some View {
        TrueFalseView()
    }
}

struct QuestionView: View {
    var question: String = ""
    var questionType: QuestionsType = .true_False
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.black.opacity(0.5))
            .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: 4)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .overlay(alignment: .leading) {
                QuestionTextView(question: question)
                    .padding(.horizontal)
            }
    }
}
