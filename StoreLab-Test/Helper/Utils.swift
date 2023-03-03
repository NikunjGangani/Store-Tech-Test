//
//  Utils.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation

class Utils {
    class func saveDataToUserDefault(_ data: Any, _ key: String) {
        let archived = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDataFromUserDefault(_ key: String) -> Any? {
        guard let archived =  UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived)
    }
    
    class func removeDataFromUserDefault(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
