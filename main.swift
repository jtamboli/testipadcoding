import Foundation

struct Signpost {
    let name: String
    let date: Date

    init(name: String, dateString: String) throws {
        guard let date = ISO8601DateFormatter().date(from: dateString) else {
            throw NSError(domain: "cx.tamboli.progress", code: 1, userInfo: ["dateString": dateString])
        }
        
        self.name = name
        self.date = date
    }
    
    func humanTimeIntervalSinceNow() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowsFractionalUnits = true
        formatter.maximumUnitCount = 2
        
        let outputString = formatter.string(from: date.timeIntervalSinceNow * -1)!
        return outputString
    }
    
    func description() -> String {
      return self.humanTimeIntervalSinceNow()
    }
}

let signposts = [
    try! Signpost(name: "New Year", 
             dateString: "2020-01-01T00:00:00-4:00"),
]

signposts.forEach { print($0.description()) }
