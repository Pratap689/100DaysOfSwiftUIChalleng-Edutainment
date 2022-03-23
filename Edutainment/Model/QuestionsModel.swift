//
//  QuestionsModel.swift
//  Edutainment
//
//  Created by netset on 02/03/22.
//

import Foundation


struct ResultSummaryModel {
    var totalQuestions, totalQuestionsAttempt, totalScoreObtained, totalScore, incorrectQuestions, correctQuestions, unansweredQues: Int
    
    init () {
        totalScore = 0
        totalQuestions = 0
        totalScoreObtained = 0
        incorrectQuestions = 0
        correctQuestions = 0
        totalQuestionsAttempt = 0
        unansweredQues = 0
    }
}

enum AnswerType: String {
    case Correct = "Correct"
    case Incorrect = "Incorrect"
    case Skipped = "Skipped"
}
struct QuestionModel: Identifiable {
    let id = UUID().uuidString
    let question: String?
    var answer: Any?
    var answerType: AnswerType = .Incorrect
    var multipleQuesOptions: Set<Int>?
}
