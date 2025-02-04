import SwiftUI

struct TimeSelectionView: View {
    @ObservedObject var viewModel: EventViewModel
    @State private var selectedTimes: [(start: String, end: String)] = [] // Track multiple selected time slots

    let timeSlots = [
        ("9:00 AM", "11:00 AM"),
        ("11:00 AM", "1:00 PM"),
        ("1:00 PM", "3:00 PM"),
        ("3:00 PM", "5:00 PM"),
        ("5:00 PM", "7:00 PM"),
        ("7:00 PM", "9:00 PM"),
        ("9:00 PM", "11:00 PM")
    ]

    var body: some View {
        VStack(spacing: 15) {
            // Event Name Section
            VStack(spacing: 10) {
                Text("Event Name")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.top)
                
                TextField("Enter event name", text: $viewModel.eventName)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.top)
            
            VStack(spacing: 10) {
                Text("Event Location")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                TextField("Enter event location", text: $viewModel.eventLocation)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }

            Text("Find a time!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(timeSlots, id: \.0) { (start, end) in
                        Button(action: {
                            toggleTimeSelection(start: start, end: end)
                            updateOverallTime()
                        }) {
                            HStack {
                                Image(systemName: isSelectedTime(start: start) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.orange)
                                Text("\(start) - \(end)")
                                    .foregroundColor(isSelectedTime(start: start) ? .white : .orange)
                                Spacer()
                            }
                            .padding()
                            .background(isSelectedTime(start: start) ? Color.orange : Color.clear)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxHeight: 250)

            NavigationLink(destination: InviteFriendsView(viewModel: viewModel)) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }

    func toggleTimeSelection(start: String, end: String) {
        if let index = selectedTimes.firstIndex(where: { $0.start == start }) {
            // If the time slot is already selected, deselect it
            selectedTimes.remove(at: index)
        } else {
            // Otherwise, add it to the selection
            selectedTimes.append((start: start, end: end))
        }
    }
    
    func isSelectedTime(start: String) -> Bool {
        // Check if the given start time is in the selected times
        return selectedTimes.contains { $0.start == start }
    }

    func updateOverallTime() {
        // Find the earliest start time and the latest end time
        guard !selectedTimes.isEmpty else {
            viewModel.selectedStartTime = Date()
            viewModel.selectedEndTime = Date()
            return
        }

        let sortedTimes = selectedTimes.sorted { convertTimeStringToDate($0.start) < convertTimeStringToDate($1.start) }
        let earliestStart = sortedTimes.first?.start ?? "9:00 AM"
        let latestEnd = sortedTimes.last?.end ?? "11:00 PM"

        viewModel.selectedStartTime = convertTimeStringToDate(earliestStart)
        viewModel.selectedEndTime = convertTimeStringToDate(latestEnd)
    }

    func convertTimeStringToDate(_ timeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.date(from: timeString) ?? Date()
    }
}




//struct TimeSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeSelectionView(viewModel: EventViewModel())
//    }
//}
