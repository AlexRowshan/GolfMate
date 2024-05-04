//
//  ScorecardViewModel.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/30/24.
//
import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct scoreData: Codable, Hashable {  //struct representing a single round of golf
    @DocumentID var id: String?
    var userId: String
    var courseName: String
    var totalScore: Int
    var stepsDuringRound: Int
    var date: Date
}

class ScorecardViewModel: ObservableObject {
    @Published var holeNumbers = Array(1...18).map { String($0) }
    @Published var parNumbers = Array(repeating: "", count: 18)
    @Published var scoreNumbers = Array(repeating: "", count: 18)
    
    var totalScore: Int {
        var score = 0
        for index in 0..<18 {
            let par = Int(parNumbers[index]) ?? 0
            let strokes = Int(scoreNumbers[index]) ?? 0
            score += strokes - par
        }
        return score
    }
    
    // The formatted total score (e.g., "Even", "+5", "-2")
    
    var formattedScore: String {
        let score = totalScore
        if score == 0{
            return "Even"
        }
        else if score > 0 {
            return "+\(score)"
        } else {
            return "\(score)"
        }
    }
     
    // Saves the completed round to Firestore
    func finishRound(courseName: String, stepsDuringRound: Int, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        let data = scoreData(userId: userId, courseName: courseName, totalScore: totalScore, stepsDuringRound: stepsDuringRound, date: Date())

        do {
            try db.collection("scores").document(userId).collection("rounds").addDocument(from: data)
            completion(nil)
        } catch let error {
            print("Error saving score data: \(error.localizedDescription)")
            completion(error)
        }
    }

}
