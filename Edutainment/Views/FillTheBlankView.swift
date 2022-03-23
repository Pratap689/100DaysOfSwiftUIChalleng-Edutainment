//
//  FillTheBlankView.swift
//  Edutainment
//
//  Created by netset on 03/03/22.
//

import SwiftUI

struct FillTheBlankView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameSetting: GameSetting
    @State private var quetionObject: [QuestionModel]?
    @State private var resultSummary: ResultSummaryModel? = ResultSummaryModel()
    @State private var userAnswer: String = ""
    @State private var questionIndex: Int = 0
    @State private var showResultView: Bool = false
    @State private var showSummary: Bool = false
    @State private var showGameEndAlert: Bool = false
    @State private var score: Int = 0
    @State private var showValidationAlert: Bool = false
    @FocusState private var isKeyboadVisible: Bool
    var body: some View {
        ZStack {
            BackgroundColors.fillIntheBalance
            VStack {
                navigationView
                VStack(alignment: .leading, spacing: -10) {
                    QuestionView(question: "\(questionIndex + 1) - \(quetionObject?[questionIndex].question ?? "")")
                        .padding()
                    
                    AnswerView(userInput: $userAnswer)
                        .focused($isKeyboadVisible)
                }
                if gameSetting.showAnswerAfterEveryQue && showResultView { resultView }
                Spacer()
                bottomButtonView()
            }
            .frame(maxHeight:.infinity, alignment: .top)
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            //Uncomment this when You Run this app
            quetionObject = gameSetting.giveAnswerArr()
            resultSummary?.totalQuestions = gameSetting.numberOfQuestions
            resultSummary?.totalScore = gameSetting.totalMarks
        })
        .onDisappear(perform: {
            quetionObject = nil
        })
        .alert(isPresented: $showGameEndAlert, content: {
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
        .alert(isPresented: $showValidationAlert, content: {
            Alert(title: Text("Alert!"), message: Text("Please enter your answer before submit"), dismissButton: .cancel())
        })
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        isKeyboadVisible = false
                        if !userAnswer.isEmpty {
                            checkUserAnswer(userAnswer: Int(userAnswer)!)
                        }
                        print("hey bro", userAnswer)
                    }
                }
            }
        }
    }
    
    private func checkUserAnswer(userAnswer: Int, isSkipped: Bool = false) {
        if userAnswer == quetionObject?[questionIndex].answer as! Int {
            resultSummary?.correctQuestions += 1
            quetionObject?[questionIndex].answerType = .Correct
            resultSummary?.totalScoreObtained += gameSetting.marksPerQue
        } else if isSkipped {
            quetionObject?[questionIndex].answerType = .Skipped
        } else {
            resultSummary?.incorrectQuestions += 1
            quetionObject?[questionIndex].answerType = .Incorrect
        }
        if !gameSetting.showAnswerAfterEveryQue {
            gotoNextQue()
        } else {
            withAnimation(.spring()) {
                print("ddddd")
                showResultView.toggle()
            }
        }
        resultSummary?.totalQuestionsAttempt += 1
    }
    
    private func gotoNextQue() {
        var index = questionIndex
        index += 1
        if (gameSetting.numberOfQuestions - 1) < index {
            showGameEndAlert.toggle()
        } else {
            questionIndex = index
        }
    }
    
    private var resultView: some View {
        ResultView(answer: quetionObject?[questionIndex], dismiss: $showResultView)
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
            .onDisappear {
                gotoNextQue()
            }
        //            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 1, y: 0, z: 0))
            .offset(y: -70)
    }
    
    private var navigationView: some View {
        VStack(alignment: .leading) {
            HStack {
                BackButton(imageName: "arrow.backward.circle.fill") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                ScoreView(totalScore:0, yourScore: $score)
                    .frame(width: 150, height: 35)
            }
            .frame(maxWidth: .infinity, maxHeight: 35)
            Text("Fill in the Blanks")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .padding()
        
    }
    
    func bottomButtonView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.6))
                .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: 4)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding()
            VStack {
                ButtonView(properties: ButtonProperties(bgColor: .black, titleColor: .pink, title: "Submit")) {
                    if userAnswer.isEmpty {
                        return showValidationAlert.toggle()
                    } else {
                        return checkUserAnswer(userAnswer: Int(userAnswer)!)
                    }
                    
                }
                .shadow(color: .pink, radius: 2, x: 0, y: -4)
                .rotation3DEffect(.degrees(-8), axis: (x: 0, y: 1, z: 0))
                .offset(x:-5)
                .padding(.horizontal)
                ButtonView(properties: ButtonProperties(bgColor: Color.init(UIColor.init(r: 0, g: 0, b: 0, a: 1)), titleColor: .pink, title: "Skip")) {
                }
                .shadow(color: .pink, radius: 2, x: 0, y: 5)
                .rotation3DEffect(.degrees(8), axis: (x: 0, y: 1, z: 0))
                .offset(x:5)
                .padding(.horizontal)
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
    }
}

struct FillTheBlankView_Previews: PreviewProvider {
    static var previews: some View {
        FillTheBlankView()
            .preferredColorScheme(.dark)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct AnswerView: View {
    @Binding var userInput: String
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.black.opacity(0.5))
            .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: 4)
            .frame(height: 55)
            .padding()
            .overlay {
                HStack {
                    TextView(properties: TextProperties(font: .headline, fontWeight: .medium, title: "Your Answer -", color: .white))
                        .padding(.horizontal)
                    TextField("", text: $userInput)
                        .foregroundColor(.white)
                        .placeholder(when: userInput.isEmpty) {
                            Text("Enter your answer").foregroundColor(.gray)
                                .overlay(alignment: .bottom) {
                                    Capsule()
                                        .frame(height: 1)
                                        .offset(y: 5)
                                        .foregroundColor(.white)
                                }
                        }
                        .keyboardType(.numberPad)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
    }
}
