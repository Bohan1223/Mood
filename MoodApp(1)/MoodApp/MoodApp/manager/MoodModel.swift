
import Foundation

struct Mood: Codable, Identifiable {
    let id: UUID
    let emoji: String
    let note: String
    let timestamp: Date
}
