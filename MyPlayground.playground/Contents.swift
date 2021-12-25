import Foundation

let now = Date()
let calendar = Calendar.autoupdatingCurrent
var components = calendar.dateComponents([.month, .year], from: now)
components.day = 1
guard let monthStart = calendar.date(from: components) else {
  fatalError("Unable to get month start date")
}
monthStart

