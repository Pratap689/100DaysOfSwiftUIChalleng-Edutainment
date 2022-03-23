//
//  SummaryCell.swift
//  Edutainment
//
//  Created by netset on 08/03/22.
//

import SwiftUI

struct SummaryCell: View {
    let answer: QuestionModel?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                TextView(properties: TextProperties(font: .headline, fontWeight: .semibold, title: "Ques- \(answer?.question ?? "")", color: colorScheme == .dark ? .black: .white))
                    .padding(.horizontal)
                TextView(properties: TextProperties(font: .system(size: 15, weight: .semibold), fontWeight: .bold, title: "Answer -\(answer?.answer as! Int)", color: colorScheme == .dark ? .black: .white))
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            Spacer()
            Image(answer?.answerType.rawValue ?? "")
                .resizable()
                .renderingMode(.original)
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .padding(.horizontal, 5)
            Text(answer?.answerType.rawValue ?? "")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(answer?.answerType == .Correct ? .green: .red)
                .frame(width: 80, alignment: .trailing)
        }
    }
    
    
}

struct SummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        SummaryCell(answer: .init(question: "1", answer: 5, answerType: .Incorrect, multipleQuesOptions: nil))
            .preferredColorScheme(.dark)
    }
}


