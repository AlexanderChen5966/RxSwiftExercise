
import Foundation

let parserArrayString = //Json Array
    """
[
  {
    "userId": 1,
    "id": 1
  },
  {
    "userId": 2,
    "id": 2
  },
  {
    "userId": 3,
    "id": 3
  },
  {
    "userId": 4,
    "id": 4
  }
]
"""

//
//let parserObjectString = //Json Object
//"""
//{
//    "data": {
//        "userItem":[
//          {
//            "userId": 1,
//            "id": 1
//          },
//          {
//            "userId": 2,
//            "id": 2
//          },
//          {
//            "userId": 3,
//            "id": 3
//          },
//          {
//            "userId": 4,
//            "id": 4
//          }
//        ]
//    }
//
//}
//"""
//let parserObjectString = "{\"event\":\"posted\",\"data\":{\"channel_display_name\":\"\",\"channel_name\":\"e6webbgbt7gp8ryb4yyheiyrcw__jbk5semtk3dhjqzcoscu7g4yhe\",\"channel_type\":\"D\",\"mentions\":\"[\\\"jbk5semtk3dhjqzcoscu7g4yhe\\\"]\",\"post\":\"{\\\"id\\\":\\\"4fu4ey9fwfbyzndnz6brycmcry\\\",\\\"create_at\\\":1516692235168,\\\"update_at\\\":1516692235168,\\\"edit_at\\\":0,\\\"delete_at\\\":0,\\\"is_pinned\\\":false,\\\"user_id\\\":\\\"e6webbgbt7gp8ryb4yyheiyrcw\\\",\\\"channel_id\\\":\\\"6jc3md8ayfycxb87fqz63jphia\\\",\\\"root_id\\\":\\\"\\\",\\\"parent_id\\\":\\\"\\\",\\\"original_id\\\":\\\"\\\",\\\"message\\\":\\\"dd\\\",\\\"type\\\":\\\"\\\",\\\"props\\\":{},\\\"hashtags\\\":\\\"\\\",\\\"pending_post_id\\\":\\\"e6webbgbt7gp8ryb4yyheiyrcw:1516692235123\\\"}\",\"sender_name\":\"bibek\",\"team_id\":\"\"},\"broadcast\":{\"omit_users\":null,\"user_id\":\"\",\"channel_id\":\"6jc3md8ayfycxb87fqz63jphia\",\"team_id\":\"\"},\"seq\":9}"


//
//let data1 = parserArrayString.data(using: String.Encoding.utf8)
//let data2 = parserObjectString.data(using: String.Encoding.utf8)
//
//
//
//func isValidJson(check data:Data) -> Bool
//{
//    do{
//    if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//        print("is NSDictionary")
//
//       return true
//    } else if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
//        print("is NSArray")
//        return true
//    } else {
//        return false
//    }
//    }
//    catch let error as NSError {
//        print(error)
//        return false
//    }
//
//}
//isValidJson(check: data1!)
//isValidJson(check: data2!)
//
//let jsonResponse = try JSONSerialization.jsonObject(with:data1!,options: []) //Array
//let jsonResponse1 = try JSONSerialization.jsonObject(with:data2!,options: []) //Dictionary


//func checkType(aaa:Any) {
////    if let dictionary = aaa as? [String: Any] {
////
////        print("是json Object")
////        return
////    }else {
////        print("不是json Object")
////        return
////    }
//    //Json是Array轉成[Any] -> [{key = value}]表示Array有Dictionary
//    if let dictionary = aaa as? [Any] {
//        print("是json Array:",dictionary)
//
//
//        if let jsonArray = dictionary as? [[String: Any]] {
//
//            print("jsonArray value",jsonArray)
//
//            for idNumber in jsonArray {
//                print("idNumber value",idNumber["id"])
//
//            }
//        }
//        return
//
//    }else {
//        print("不是json Array")
//
//        if let jsonArray = aaa as? [String: Any] {
//            print("jsonArray value",jsonArray)
//            if let dict = jsonArray["data"] as? NSDictionary{
//                print("dict value",dict)
//
//                if let jsonArray1 = dict["userItem"] as? [[String: Any]] {
//                    print("jsonArray1 value",jsonArray1)
//
//                    for idNumber in jsonArray1 {
//                        print("idNumber value",idNumber["id"])
//
//                    }
//                }
//
//            }
////
////            print("data value",jsonArray["data"])
////            if let jsonArray1 = jsonArray["data"] as? [String: Any] {
////                print("jsonArray1 value:",jsonArray1["userItem"])
////
////
////            }
//
//        }
//
//        return
//    }
//
//
//}
//checkType(aaa: jsonResponse)//Array
//checkType(aaa: jsonResponse1)//Object

let parseObjectString = //JSON with object root
"""
{
    "name": "Caffè Macs",
    "coordinates": {
        "lat": 37.330576,
        "lng": -122.029739
    },
    "meals": ["breakfast", "lunch", "dinner"]
}
"""

let stringObjectData = parseObjectString.data(using: String.Encoding.utf8)
//1. 使用JSONSerialization的方式進行Json Parse
let jsonObject = try? JSONSerialization.jsonObject(with: stringObjectData!, options: [])
print(type(of: jsonObject))
//最外層是{}就轉成Dictionary
let dictionary = jsonObject as? [String: Any]
print(type(of: dictionary))

let dictionary1 = jsonObject as? Dictionary<String,Any>
print(type(of: dictionary1))

  
let name = dictionary!["name"] as? String
let coordinatesJSON = dictionary!["coordinates"] as? [String:Double]
let latitude = coordinatesJSON!["lat"]
let longitude = coordinatesJSON!["lng"]
let mealsJson = dictionary!["meals"] as? [String]



let stringArrayData = parserArrayString.data(using: String.Encoding.utf8)
let jsonArray = try? JSONSerialization.jsonObject(with: stringArrayData!, options: [])
print(type(of: jsonArray))
//最外層是[]就轉成陣列
let jsonWithArrayRoot = jsonArray as? [Any]
print(type(of: jsonWithArrayRoot))

let dictionaryWithArray = jsonWithArrayRoot as? [[String:Any]]
print(type(of: dictionaryWithArray))


for object in dictionaryWithArray! {
    object["id"]
}


//使用Swift4 Codable的方式進行parse
struct WebAPIModel: Codable {
    let name: String
    let coordinates: Coordinates
    let meals: [String]
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, lng: Double
}


let decoder = JSONDecoder()
let decoderObject = try! decoder.decode(WebAPIModel.self, from: stringObjectData!)
print("decoderObject:\(decoderObject)")
decoderObject.name
decoderObject.meals
decoderObject.coordinates


