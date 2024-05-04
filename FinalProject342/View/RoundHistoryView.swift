import SwiftUI
import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

struct RoundHistoryView: View {
    // The view model for the round history
    @StateObject private var viewModel = RoundHistoryViewModel()
    // The view model for the statistics
    @StateObject var statsViewModel = StatsViewModel()
    // The selected date
    @State private var selectedDate: Date?

    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) { // Displays the round history and calendar
                Text("Round History")
                    .font(.title2)
                    .padding(.bottom, 5)

                CalendarView(viewModel: statsViewModel, selectedDate: $selectedDate)
                    .frame(height: 350) // Adjust the height as needed

                if let selectedDate = selectedDate {
                    Text("Rounds on \(selectedDate, formatter: dateFormatter):")
                    ForEach(filteredRounds, id: \.id) { round in
                        RoundView(round: round)
                            .frame(width: 300, height: 150)
                    }
                } else {
                    Text("Select a date to see your rounds")
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchRounds()
            statsViewModel.fetchStatistics()
        }
        .navigationTitle("Course History")
    }

    private var filteredRounds: [scoreData] { // Filters the rounds to only those on the selected date
        guard let date = selectedDate else { return [] }
        return viewModel.rounds.filter { $0.date.startOfDay == date.startOfDay }
    }

    // Define a view for displaying individual rounds
    private func RoundView(round: scoreData) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Course: \(round.courseName)")
                .font(.headline)
            Text("Date: \(round.date.formatted(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
            Text("Total Score: \(round.totalScore)")
                .font(.subheadline)
            Text("Steps: \(round.stepsDuringRound)")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding(.horizontal)
    }

    private let dateFormatter: DateFormatter = {  // A date formatter for the round dates
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

struct RoundHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RoundHistoryView()
    }
}
