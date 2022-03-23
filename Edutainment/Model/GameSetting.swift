//
//  GameSetting.swift
//  Edutainment
//
//  Created by netset on 02/03/22.
//

import Foundation

enum DificultyLevel: String {
    case high = "High 🤯"
    case low = "Easy 😌"
    case medium = "Medium 🥵"
}

enum QuestionsType: String {
    case true_False = "True False"
    case fill_In_Blank = "Fill The Answer"
    case multipleChoice = "Multiple Choice"
}

class GameSetting: ObservableObject {
    @Published var difficultyLevel: DificultyLevel = .low
    @Published var tableNumber: Int = 2
    @Published var gameType: QuestionsType = .true_False
    @Published var showResultsInEnd: Bool = true
    @Published var showAnswerAfterEveryQue: Bool = false
    @Published var numberOfQuestions: Int = 1
    @Published var questionTypeArr: [QuestionsType] = [.true_False, .fill_In_Blank, .multipleChoice]
    @Published var totalMarks: Int = 2
    @Published var marksPerQue: Int = 2
    var choosenNumbers = Set<Int>()
    
    init() {
          print(">> inited")
      }

      deinit {
          print("[x] destroyed")
      }
    
    func giveAnswerArr() -> [QuestionModel] {
        var questionsArr = [QuestionModel]()
        while numberOfQuestions != questionsArr.count {
            let noToMultiply = Int.random(in: 1...10)
            choosenNumbers.insert(noToMultiply)
            guard let question = generateQuestionString(noToMultiply) else { return [] }
            questionsArr.append(question)
        }
        print("here are the choosen no", choosenNumbers)
        return questionsArr
    }
    
    func generateQuestionString(_ number: Int) -> QuestionModel? {
        let answer = tableNumber * number
        var ques: QuestionModel?
        switch gameType {
        case .true_False:
            ques = QuestionModel(question: "Is \(tableNumber)x\(number) = \(answer)?", answer: answer)
        case .fill_In_Blank:
            ques = QuestionModel(question: "What is \(tableNumber)x\(number)?", answer: answer)
        case .multipleChoice:
            var multipleSet = Set<Int>()
            while multipleSet.count != 3 {
                multipleSet.insert(Int.random(in: (answer+1)...(answer+40)))
            }
            multipleSet.insert(answer)

            ques = QuestionModel(question: "Choose from the given options. What \(tableNumber)x\(number) will be?", answer: answer, multipleQuesOptions: multipleSet)
        }
        return ques
    }
}
