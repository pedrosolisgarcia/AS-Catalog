import Foundation

public class ShopIdManager {
    
    static func validShopIds() -> [String] {
        return ["WRO-ID", "KRK-ID", "WAW-ID", "TST-ID"]
    }
    
    class func isThereAnyShopIdRegisteredAlready() -> Bool {
        return UserDefaults.standard.object(forKey: "SHOP-ID") != nil
    }
    
    class func saveShopIdInIPad(shopId: String) -> String? {
        UserDefaults.standard.setValue(shopId, forKey: "SHOP-ID")
        print("Value changed to " + UserDefaults.standard.string(forKey: "SHOP-ID")!)
        return UserDefaults.standard.string(forKey: "SHOP-ID")
    }
    
    class func retrieveIPadShopId() -> String? {
        print("Value to be used: " + UserDefaults.standard.string(forKey: "SHOP-ID")!)
        return UserDefaults.standard.string(forKey: "SHOP-ID")
    }
    
}
