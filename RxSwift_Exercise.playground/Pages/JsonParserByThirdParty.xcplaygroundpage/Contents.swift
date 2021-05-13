import Foundation
import SwiftyJSON
import ObjectMapper
import HandyJSON


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

let parserObjectString = //Json Object
"""
{
    "data": {
        "userItem":[
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
    }
}
"""

//if let arrayDataFromString = parserArrayString.data(using: .utf8, allowLossyConversion: false) {
//    let json = try! JSON(data: arrayDataFromString)
//    json[0]["userId"]
//}

//if let objectDataFromString = parserObjectString.data(using: .utf8, allowLossyConversion: false) {
//    let json = try! JSON(data: objectDataFromString)
//    json["data"]["userItem"][1]["userId"]
//}


//let jsonArrayData = JSON(parserArrayString)
//let jsonObjectData = JSON(parserObjectString)

//SwiftyJSON
let scenes1JSONString = //Json Object
"""
{
  "results": [
    {
      "type": "song",
      "id": 99,
      "name": "披星戴月的想你"
    ,"email":[]

    },
    {
      "type": "user",
      "id": 1,
      "name": "zhgchgli",
      "email": "zhgchgli@gmail.com"
    }
  ]
}
"""

//if let scenes1DataFromString = scenes1JSONString.data(using: .utf8, allowLossyConversion: false) {
//    let json = try! JSON(data: scenes1DataFromString)
//
//    json["results"].count
//    json["results"][0]["email"].stringValue
//
//    if let email =  json["results"][0]["email"].string {
//        print(email)
//    }else {
//        //印出錯誤訊息
//        print(json["results"][0]["email"])
//    }
//}



let scenes2JSONString = //Json Object
"""
[
  {
    "type": "song",
    "id": 99,
    "name": "披星戴月的想你"
  },
    {
    "type": "song",
    "id": 11
  }
]
"""

//if let  scenes2DataFromString = scenes2JSONString.data(using: .utf8, allowLossyConversion: false) {
//    let json = try! JSON(data: scenes2DataFromString)
//
//    json.count
//    json[1]["name"]
//
//    if let email =  json[0]["name"].string {
//        print(email)
//    }else {
//        //印出錯誤訊息
//        print(json[0]["name"])
//    }
//}


let scenes3JSONString = //Json Object
"""
{
  "results": [
    {
      "type": "song",
      "id": 99,
      "name": "披星戴月的想你"
    },
    {
      "error": "errro"
    },
    {
      "type": "song",
      "id": 19,
      "name": "帶我去找夜生活"
    }
  ]
}
"""

//if let  scenes3DataFromString = scenes3JSONString.data(using: .utf8, allowLossyConversion: false) {
//    let json = try! JSON(data: scenes3DataFromString)
//
//    json["results"].count
//
//    if let email =  json["results"][1]["error"].string {
//        print(email)
//    }else {
//        //印出錯誤訊息
//        print(json["results"][1]["error"])
//    }
//}


let scenes4JSONString = //Json Object
"""
{
  "results": [
    {
      "id": 123456,
      "comment": "是告五人，不是五告人!",
      "target_object": {
        "type": "song",
        "id": 99,
        "name": "披星戴月的想你"
      },
      "commenter": {
        "type": "user",
        "id": 1,
        "name": "zhgchgli",
        "email": "zhgchgli@gmail.com"
      }
    },
    {
      "id": 55,
      "comment": "66666!",
      "target_object": {
        "type": "user",
        "id": 1,
        "name": "zhgchgli"
      },
      "commenter": {
        "type": "user",
        "id": 2,
        "name": "aaaa",
        "email": "aaaa@gmail.com"
      }
    }
  ]
}
"""
//"type": "user",
//"id": 1,
//"name": "zhgchgli",
//"email": "zhgchgli@gmail.com"
//HandyJSON

struct BasicTypes1: HandyJSON {
    var results: [BasicSubTypes1] = []

}
struct BasicSubTypes1: HandyJSON {
    var type: String = ""
    var id: Int = 0
    var name: String = ""
    var email: String = ""

}

//if let aaa = BasicTypes1.deserialize(from: scenes1JSONString) {
//    print(aaa.results[0])
//    print(aaa.results[1])
//
//    aaa.results.forEach { (aa) in
//        print(aa.email)
//    }
//}

struct BasicTypes2: HandyJSON {
    var type: String = ""
    var id: Double?
    var name: String?

}

//if let bbb = [BasicTypes2].deserialize(from: scenes2JSONString) {
//    bbb.forEach({ (bb) in
//        print(bb?.name)
//    })
//}

//ObjectMapper

class BasicObjectMapperTypes1: Mappable {
    
    var result: [BasicSubObjectMapperTypes1] = []
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        result    <- map["results"]
    }
    

}

class BasicSubObjectMapperTypes1: Mappable {
    var type: String = ""
    var idNumber: Int = 0
    var name: String = ""
    var email:String?
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        type     <- map["type"]
        idNumber <- map["id"]
        name     <- map["name"]
        email   <- map["email"]
    }
}

let eee = BasicObjectMapperTypes1(JSONString: scenes1JSONString)
eee?.result[0].email

let scenes5JSONString = //Json Object
"""
{
    "results": {
        "type": "user",
        "id": 2,
        "name": "aaaa",
        "email": "aaaa@gmail.com"
    }
}
"""

class BasicObjectMapperTypes2: Mappable {
    
    var type: String = ""
    var idNumber: Int = 0
    var name: String = ""
    var email:String?
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        type     <- map["results.type"]
        idNumber <- map["results.id"]
        name     <- map["results.name"]
        email   <- map["results.email"]
    }

}
//let fff = BasicObjectMapperTypes2(JSONString: scenes5JSONString)
//fff?.email


//Codable
struct WebAPIModel: Codable {
    let results: [Result]
}

struct RelaxedString: Codable {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        // attempt to decode from all JSON primitives
        if let str = try? container.decode(String.self) {
            value = str
        } else if let int = try? container.decode(Int.self) {
            value = int.description
        } else if let double = try? container.decode(Double.self) {
            value = double.description
        } else if let bool = try? container.decode(Bool.self) {
            value = bool.description
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

struct Result: Codable {
    let type: String
    let id: Int
    let name: String
//    let email: String?
    let email: RelaxedString?

    private enum CodingKeys: String, CodingKey {
        case type = "type", id = "id", name = "name",email = "email"
    }


    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
//        email = try container.decode(RelaxedString.self, forKey: .email)
        email = try container.decodeIfPresent(RelaxedString.self, forKey: .email)

//        do {
//
//            email = try String(container.decode(Int.self, forKey: .email))
//        }catch DecodingError.typeMismatch {
//            email = try container.decode(String.self, forKey: .email)
//        }

    }
    
}

let scenes1DataFromString = scenes1JSONString.data(using: .utf8, allowLossyConversion: false)
let decoder = JSONDecoder()
let decoderObject = try! decoder.decode(WebAPIModel.self, from: scenes1DataFromString!)
print("decoderObject:\(decoderObject)")



public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        
        default:
            hasher.combine(0)
        }
    }

    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


public class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}


