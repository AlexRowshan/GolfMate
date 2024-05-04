//
//  StatsViewModel.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/30/24.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase
import Charts
import DGCharts

class StatsViewModel: ObservableObject {
    @Published var handicap: String = "..."
    @Published var bestRound: String = "..."
    @Published var bestRounds: [scoreData] = []
    @Published var totalSteps: Int = 0


    func fetchStatistics() {  // Fetches the user's statistics from Firestore
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let roundsCollection = db.collection("scores").document(userId).collection("rounds")

        roundsCollection.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching rounds: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No rounds found")
                return
            }

            let rounds = documents.compactMap { document -> scoreData? in
                try? document.data(as: scoreData.self)
            }

            // Calculate total steps
            self.totalSteps = rounds.reduce(0) { $0 + $1.stepsDuringRound }

            // Calculate the handicap and best rounds as before
            if rounds.isEmpty {
                self.handicap = "N/A"
            } else {
                let totalScore = rounds.reduce(0) { $0 + $1.totalScore }
                let averageScore = Double(totalScore) / Double(rounds.count)
                let roundedHandicap = Int(round(averageScore))
                self.handicap = String(roundedHandicap)
            }

            let sortedRounds = rounds.sorted { $0.totalScore < $1.totalScore }
            if let lowestScore = sortedRounds.first?.totalScore {
                let bestRounds = sortedRounds.filter { $0.totalScore == lowestScore }
                self.bestRound = String(lowestScore)
                self.bestRounds = bestRounds
            } else {
                self.bestRound = "N/A"
                self.bestRounds = []
            }
        }
    }

}


