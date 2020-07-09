import Foundation

extension FileManager {
  func getBasePath() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0].appendingPathComponent("DRESS_COLLECTION")
  }
}
