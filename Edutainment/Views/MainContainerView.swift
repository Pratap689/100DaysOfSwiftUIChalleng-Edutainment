//
//  MainContainerView.swift
//  Edutainment
//
//  Created by netset on 02/03/22.
//

import SwiftUI

struct MainContainerView: View {
    
    var gameType: QuestionsType = .true_False
    var transition: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
    
    var body: some View {
        switch gameType {
        case .true_False:
            TrueFalseView()
                .transition(transition)
        case .fill_In_Blank:
            FillTheBlankView()
                .transition(transition)
        case .multipleChoice:
            MultipleChoiceQue()
                .transition(transition)
        }
    }
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerView()
    }
}
