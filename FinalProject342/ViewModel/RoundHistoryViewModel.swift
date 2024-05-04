import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class RoundHistoryViewModel: ObservableObject {
    @Published var rounds = [scoreData]()
    // Fetches the user's past golf rounds from Firestore
    func fetchRounds() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Get the rounds collection for the current user, sorted by date in descending order
        let db = Firestore.firestore()
        let roundsCollection = db.collection("scores").document(userId).collection("rounds").order(by: "date", descending: true)
        
        roundsCollection.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching rounds: \(error.localizedDescription)")
                return
            }
            
            // Convert the Firestore documents to scoreData instances and store them in the rounds array
            
            self.rounds = querySnapshot?.documents.compactMap { document -> scoreData? in
                try? document.data(as: scoreData.self)
            } ?? []
        }
    }
}

