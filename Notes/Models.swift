
import Foundation

struct Note {
    var title: String
    var contents: String
    let created = NSDate()
    let id = NSUUID().UUIDString
    
    init(title: String, contents: String) {
        self.title = title
        self.contents = contents
    }
    
    init?(dictionary: Dictionary<String,String>) {
        guard let title = dictionary["title"], let contents = dictionary["contents"] else {
            return nil
        }
        self.title = title
        self.contents = contents
    }
    
    func encode() -> Dictionary<String,String> {
        return ["title": title, "contents": contents]
    }
}