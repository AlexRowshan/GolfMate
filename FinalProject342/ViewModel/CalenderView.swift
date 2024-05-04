import SwiftUI
import UIKit

//display a calendar and allow the user to select a date

struct CalendarView: UIViewRepresentable { //UICalendarView is a UIKit view that needs to be integrated into the SwiftUI-based user interface.
    // The view model for the statistics, used to fetch data related to the selected date
    @ObservedObject var viewModel: StatsViewModel
    // A binding to the selected date, which will be updated when the user selects a date
    @Binding var selectedDate: Date?
    
    // This method is called to create the underlying UIKit view
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.calendar = .current
        calendarView.fontDesign = .monospaced
        return calendarView
    }
    
    // This method is called whenever the view needs to be updated
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if let selectedDate = selectedDate {
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
            uiView.setVisibleDateComponents(dateComponents, animated: true)
        }
    }
    
    // This method is called to create the coordinator, which will handle user interactions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // The coordinator class, which implements the `UICalendarViewDelegate` protocol
    class Coordinator: NSObject, UICalendarViewDelegate {
        var parent: CalendarView
        
        // Initializes the coordinator with a reference to the parent `CalendarView`
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            return nil
        }
        
        // This method is called when the user changes the visible date components in the calendar view
        func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
            parent.selectedDate = calendarView.visibleDateComponents.date
        }
    }
}
