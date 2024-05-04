//
//  Stats.swift
//  FinalProject342
//
//  Created by Alex Rowshan on 4/29/24.
//
import SwiftUI
import Firebase
import Foundation

struct Stats: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var err: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Top section
                    HStack {
                        Spacer()
                        Text("GolfMate")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Spacer()
                    }
                    .padding(.top)

                    if !err.isEmpty {
                        Text(err)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }

                    // Statistics section
                    VStack(spacing: 20) {
                        HStack {
                            Text("Handicap:")
                                .font(.title2)
                                .foregroundColor(.green)

                            Text("\(viewModel.handicap)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }

                        HStack {
                            Text("Total Steps Taken:")
                                .font(.title2)
                                .foregroundColor(.green)

                            Text("\(viewModel.totalSteps)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Best Round:")
                                .font(.title2)
                                .foregroundColor(.green)

                            ForEach(viewModel.bestRounds, id: \.id) { round in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(round.courseName)
                                            .font(.headline)

                                        Text(round.date.formatted())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Text("Score: \(round.totalScore)")
                                        .font(.title3)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Stats")
            .background(Color(.systemGray6))
        }
        .onAppear {
            viewModel.fetchStatistics()
        }
    }
}
