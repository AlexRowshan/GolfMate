import SwiftUI
import Firebase

struct ScorecardView: View {
    // The name of the course
        let courseName: String
        // Allows the view to be dismissed
        @Environment(\.presentationMode) var presentationMode
        // The view model for the scorecard
        @StateObject private var viewModel = ScorecardViewModel()
        // Flag to show the cancel confirmation alert
        @State private var showCancelConfirmation = false
        // The HealthKit view model
        @StateObject var healthKitManager = HealthKitViewModel.shared
        // Flag to track if steps are being tracked
        @State private var isTrackingSteps = false

    var body: some View {
        NavigationView {
            VStack {
                courseInfo
                scoreList
                trackingControls
                Spacer()
            }
            .padding()
            .alert(isPresented: $showCancelConfirmation, content: cancelRoundAlert)
            .navigationBarItems(leading: cancelButton, trailing: finishRoundButton)
            .navigationTitle("Scorecard")
        }
    }

    var courseInfo: some View { // Displays the course name
        Text("Course: \(courseName)")
            .font(.headline)
            .padding(.bottom)
    }

    var scoreList: some View {  // Displays the list of scores
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerRow
                ForEach(0..<18) { index in
                    HStack {
                        Text(viewModel.holeNumbers[index])
                            .font(.headline)
                            .frame(width: 50)
                        TextField("Par", text: $viewModel.parNumbers[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                        TextField("Score", text: $viewModel.scoreNumbers[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    var headerRow: some View {
        HStack {
            Text("Hole").fontWeight(.bold).frame(width: 50)
            Text("Par").fontWeight(.bold).frame(width: 80)
            Text("Score").fontWeight(.bold).frame(width: 80)
        }
        .padding(.bottom, 8)
    }

    var trackingControls: some View {
        VStack {
            if isTrackingSteps {
                Text("Steps are being tracked")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
            } else {
                Button("Track Steps") {
                    healthKitManager.startTrackingSteps()
                    isTrackingSteps = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Text("Total Score: \(viewModel.formattedScore)")
                .font(.headline)
                .padding()
        }
    }

    var cancelButton: some View {  // The cancel button in the navigation bar
        Button(action: {
            showCancelConfirmation = true
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.green)
        }
    }

    var finishRoundButton: some View { // The finish round button in the navigation bar
        Button(action: {
            let stepsTaken = healthKitManager.getStepsDuringRound()
            viewModel.finishRound(courseName: courseName, stepsDuringRound: stepsTaken) { error in
                if error == nil {
                    healthKitManager.stopTrackingStepsAndPrint()
                    presentationMode.wrappedValue.dismiss()
                } else {
                    print("Error finishing round: \(error!.localizedDescription)")
                }
            }
        }) {
            Text("Finish")
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 26))
        }
        .background(Color.green)
        .cornerRadius(8) // Reduced corner radius
        .padding(.top, 40) // Increased bottom padding
        .padding(.leading, 20) // Kept the leading padding
    }
    
    func cancelRoundAlert() -> Alert { // Displays the cancel round confirmation alert
        Alert(
            title: Text("Cancel Round"),
            message: Text("Are you sure you want to cancel your round?"),
            primaryButton: .destructive(Text("Cancel Round")) {
                healthKitManager.cancelTrackingSteps()
                presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .default(Text("Stay in Round"))
        )
    }
}
