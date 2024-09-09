import Foundation

public class JsonHelper {
  static func jsonMessageToDictionary(_ data: Any?) -> [String:Any] {
        var messageDic: [String: Any] = [:]
        guard let messageText = data as? String else {
            print("error")
            return [:]
        }
        if let data = messageText.data(using: .utf8) {
            do {
                messageDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            } catch {
                print(error.localizedDescription)
                return [:]
            }
        }
        
        return messageDic
    }
    
    static func convertDictionaryToJsonString(of params: Any) -> String{
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted
        ),
        let theJSONText = String(data: theJSONData,
                                 encoding: String.Encoding.ascii) {
            return theJSONText
        }
        
        return ""
    }
    
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
    }
}