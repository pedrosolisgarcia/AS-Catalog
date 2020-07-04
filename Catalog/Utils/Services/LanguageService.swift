import Foundation

public class LanguageService {
  
  public static let shared = LanguageService()
  
  public func getCurrentLanguage() -> String? {
    return UserDefaults.standard.string(forKey: "AppleLanguage")
  }
  
  public func setLanguage(to lang: String) -> Void {
    if lang == getCurrentLanguage() {
      return
    }
    UserDefaults.standard.set(lang, forKey: "AppleLanguage")
    print("Language changed to " + self.getCurrentLanguage()!)
  }
}
