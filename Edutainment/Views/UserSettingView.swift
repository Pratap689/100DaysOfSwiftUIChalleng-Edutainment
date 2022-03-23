//
//  UserSettingView.swift
//  Edutainment
//
//  Created by netset on 03/03/22.
//

import SwiftUI

struct UserSettingView: View {
    @StateObject var gameSettingObj: GameSetting = GameSetting()
    var tableArray: [Int]  {
        var tableArray = [Int]()
        var startFrom = Int()
        switch gameSettingObj.difficultyLevel {
        case .low:
            startFrom = 1
        case .medium:
            startFrom = 10
        case .high:
            startFrom = 20
        }
        tableArray.removeAll()
        while tableArray.count != 10 {
            startFrom += 1
            tableArray.append(startFrom)
        }
        return tableArray
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var difficultLevel: [DificultyLevel] = [.low, .medium, .high]
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    //User Settings Views
                    DifficultyLevelView(difficultylevel: $gameSettingObj.difficultyLevel, difficultLevel: difficultLevel) {
                        gameSettingObj.tableNumber = tableArray.first ?? 0
                        return calculateTotalAndPerQueMarks()
                    }
                    SelectTableView(tableArr: tableArray, tableNumber: $gameSettingObj.tableNumber)
                    NumberOfQueView(numberOfQuestion: $gameSettingObj.numberOfQuestions)
                        .onChange(of: gameSettingObj.numberOfQuestions, perform: { newValue in
                            calculateTotalAndPerQueMarks()
                        })
                    QuetionTypeView(gameType: $gameSettingObj.gameType, dataSource: gameSettingObj.questionTypeArr)
                    ResultSettingView(showResultInEnd: $gameSettingObj.showResultsInEnd, showResultAfterEachQue: $gameSettingObj.showAnswerAfterEveryQue)
                }
                .background(
                    BackgroundColors.userSettingBGColor
                )
                //Start Game
                startGameButton
            }
            .navigationTitle("Table Game For Kids")
        }
        .environmentObject(gameSettingObj)
        .background(.clear)
    }
    
    private var startGameButton: some View {
        NavigationLink(destination: MainContainerView(gameType: gameSettingObj.gameType )) {
            Text("Start Game")
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, maxHeight: 55)
                .background(.black)
                .cornerRadius(10)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    private func calculateTotalAndPerQueMarks() {
        var marksPerQue = 1
        var totalMarks = gameSettingObj.numberOfQuestions
        switch gameSettingObj.difficultyLevel {
        case .high: marksPerQue = 10
        case .medium: marksPerQue = 5
        case .low: marksPerQue = 2
        }
        totalMarks *= marksPerQue
        gameSettingObj.totalMarks = totalMarks
        gameSettingObj.marksPerQue = marksPerQue
    }
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
            .preferredColorScheme(.dark)
    }
}

struct SettingNameView: View {
    
    var settingName: String = ""
    var body: some View {
        Text(settingName)
            .foregroundColor(.primary)
            .font(.callout)
            .fontWeight(.semibold)
        Spacer()
    }
}

struct DifficultyLevelView: View {
    
    @Binding var difficultylevel: DificultyLevel
    var difficultLevel: [DificultyLevel]
    var updateTable: ()->()?
    var body: some View {
        HStack {
            SettingNameView(settingName: "Select Difficulty Level")
            Menu {
                Picker(selection: $difficultylevel, label: EmptyView()) {
                    ForEach(difficultLevel, id: \.self) {
                        Text($0.rawValue)
                    }
                }.onChange(of: difficultylevel) { newValue in
                    print("new value", newValue)
                    updateTable()
                }
            } label: {
                Text(difficultylevel.rawValue)
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct SelectTableView: View {
    var tableArr: [Int]
    @Binding var tableNumber: Int
    var body: some View {
        HStack {
            SettingNameView(settingName: "Select the Table")
            Picker(selection: $tableNumber, label: EmptyView()) {
                ForEach(tableArr, id: \.self) {
                    Text("\($0)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                }
            }
            .frame(width: 50, alignment: .trailing)
        }
    }
}

struct NumberOfQueView: View {
    @Binding var numberOfQuestion: Int
    var body: some View {
        HStack {
            SettingNameView(settingName: "Number of Questions:-  \(numberOfQuestion)")
            Stepper("Select Number Of Que", value: $numberOfQuestion, in: 1...10)
                .labelsHidden()
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.vertical)
    }
}

struct QuetionTypeView: View {
    @Binding var gameType: QuestionsType
    var dataSource: [QuestionsType]
    var body: some View {
        Section {
            Picker("Select Options", selection: $gameType) {
                ForEach(dataSource, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(.segmented)
        } header: {
            Text("Select Quetion Type")
                .font(.headline)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
        }
    }
}

struct ResultSettingView : View {
    @Binding var showResultInEnd: Bool
    @Binding var showResultAfterEachQue: Bool
    var body: some View {
        VStack {
            HStack {
                SettingNameView(settingName: "Show Result in the End")
                Toggle("Show Result", isOn: $showResultInEnd)
                    .labelsHidden()
                    .tint(.orange)
            }
            HStack {
                SettingNameView(settingName: "Show Result After Each Question")
                Toggle("Show Result", isOn: $showResultAfterEachQue)
                    .labelsHidden()
                    .tint(.orange)
            }
        }
    }
}
