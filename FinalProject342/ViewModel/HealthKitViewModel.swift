//

//  HealthKitViewModel.swift

//  FinalProject342

//

//  Created by Alex Rowshan on 4/30/24.

//

import Foundation

import HealthKit

class HealthKitViewModel: ObservableObject {

    static let shared = HealthKitViewModel()

    private var healthStore = HKHealthStore()

    private var stepsDuringRound: Int = 0

    private var anchor: HKQueryAnchor?

    private var isTracking = false

    init() {

        requestHealthKitAuthorization()

    }
    
    // Requests authorization to access HealthKit step count data
    private func requestHealthKitAuthorization() {

        guard HKHealthStore.isHealthDataAvailable() else {

            print("HealthKit is not available on this device.")

            return

        }

        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {

            print("Step Count Type is unavailable.")

            return

        }

        healthStore.requestAuthorization(toShare: nil, read: Set([stepCountType])) { success, error in

            if !success {

                print("Authorization not granted: \(error?.localizedDescription ?? "Unknown error")")

            }

        }

    }

    // Starts tracking the steps taken during the current round
    func startTrackingSteps() {

        if !isTracking {

            stepsDuringRound = 0 // Reset steps count at the start of tracking

            setupStepCountQuery()

            isTracking = true

        }

    }
    // Stops tracking the steps and prints the total steps taken during the round

    func stopTrackingStepsAndPrint() {

        isTracking = false

        print("Steps taken during the round: \(stepsDuringRound)")

        healthStore.stop(anchorQuery)

    }

    // Cancels the step tracking and resets the steps count
    func cancelTrackingSteps() {

        isTracking = false

        stepsDuringRound = 0

        healthStore.stop(anchorQuery)

    }
    
    // The anchor query for the step count data

    private var anchorQuery: HKAnchoredObjectQuery!
    
    // Sets up the step count query

    private func setupStepCountQuery() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }

        // Record the start time when tracking begins.
        let startDate = Date()

        // Create a predicate to fetch steps taken after the start date.
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)

        let query = HKAnchoredObjectQuery(type: stepType,
                                          predicate: predicate,
                                          anchor: anchor,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, newAnchor, error in

            self.anchor = newAnchor
            self.updateSteps(with: samples)
        }

        query.updateHandler = { query, samples, deletedObjects, newAnchor, error in
            self.anchor = newAnchor
            self.updateSteps(with: samples)
        }

        healthStore.execute(query)
        anchorQuery = query
    }


    // Updates the step count during the current round
    private func updateSteps(with samples: [HKSample]?) {

        print("Updating")

        guard let quantitySamples = samples as? [HKQuantitySample] else { return }

        let newSteps = quantitySamples.reduce(0) { $0 + Int($1.quantity.doubleValue(for: HKUnit.count())) }

        DispatchQueue.main.async {

            self.stepsDuringRound += newSteps

        }

    }
    
    func getStepsDuringRound() -> Int {
            return stepsDuringRound
        }

}
