import RxSwift
import RxCocoa
import PlaygroundSupport
import UIKit
import Foundation
import SnapKit

//MARK:使用RxSwift製作URLRequest

public struct WebAPIModelElement: Codable {
    public let userId:Int?
    public let id:Int
    public let title:String
    public let body:String?

}

/*:
 ### 接著會以URL發出請求當作範例
 ### 會比較貼近實際開發的狀況
 ---
 接下來會以下面的網址當作測試資料
 https://jsonplaceholder.typicode.com/posts
 用來測試http statusCode
 https://httpstat.us/404
 */


let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//let url = URL(string: "https://httpstat.us/404")!
var request = URLRequest(url: url)

enum HTTPError: Error {
    case statusCode
    case post
}

/*:
 ### 為了比較未使用RxSwift，與使用RxSwift的差異所以兩種方式都會寫
 
 ### 一般使用URLSession的方法
 */

let sessionTask1 = URLSession.shared.dataTask(with: request){
    (data, response, error) in
    
    if let error = error {
        print("Error: \(error.localizedDescription)")
    }
    guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
        print("Error: 非正常的HTTP狀態碼")
        return
    }
    guard let data = data else {
        print("Error: missing data")
        return
    }
    print(data)
    //接著就可以進行Json Parser
}
sessionTask1.resume()



/*:
 ### 使用Rxswift的URLSession方法
 */
let disposeBag = DisposeBag()


//1 透過rx.response發出請求

let sessionTask2 = URLSession.shared.rx.response(request: request)

sessionTask2.subscribe{
    (response,data) in

    guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
        print("Error: 非正常的HTTP狀態碼")
        return
    }

    
    if 200 ..< 300 ~= response.statusCode {
        let str = String(data: data, encoding: String.Encoding.utf8)
//        print("rx.response請求成功，回傳資料為：\(str)")

    } else {
        print("Error: 非正常的HTTP狀態碼")
    }


}.disposed(by: disposeBag)



//2 透過rx.data發出請求
let sessionTask3 =
    URLSession.shared.rx.data(request: request)
sessionTask3.subscribe(onNext: {
    data in
    let str = String(data: data, encoding: String.Encoding.utf8)

//    print("rx.data請求成功，回傳資料為：\(str)")
}, onError: {
    error in
    print("請求失敗:\(error)")
}, onCompleted: {

}, onDisposed: {

}).disposed(by: disposeBag)


//rx.response與rx.data的區別
//如果不需要底層的response資訊，只需要請求成功時的結果，就建議使用rx.data
//rx.data會自動判斷http status code，只有200~300的status code才會進入，onNext的call back，否則都會進入onError的call back

//3 使用rx.json發出請求，直接將json導出
let sessionTask4 = URLSession.shared.rx.json(request: request)

sessionTask4.subscribe(onNext: {
    data in
    let json = data as! [Any]
//    debugPrint("rx.json請求成功，回傳資料為：\(json)")
    
}, onError: {
    error in
}, onCompleted: {
    
}, onDisposed: {
    
}).disposed(by: disposeBag)





//https://www.hangge.com/blog/cache/detail_2010.html
//"https://httpstat.us/404"
//"https://jsonplaceholder.typicode.com/posts"
//let urlString = "https://httpstat.us/500"
//let urlString = "https://jsonplaceholder.typicode.com/posts"
//let urlString = "https://jsonplaceholder.typicode.com/users/1"

//let url = URL(string: urlString)!
//var request = URLRequest(url: url)



/*:
 ###
 會使用RXSwift發出請求後，接著再繼續將得到的回應轉換成JSON
 */
//將結果轉能Json的對象

//1 使用JSONSerialization
URLSession.shared.rx.data(request: request).subscribe(onNext:{
    data in
    let json  = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//    debugPrint("請求成功，回傳資料為JSONSerialization：\(json)")
}) { (error) in
    debugPrint("請求失敗:\(error)")
}.disposed(by: disposeBag)


//也可以在subscribe之前就先進行轉換
URLSession.shared.rx.data(request: request)
    .map{
        try JSONSerialization.jsonObject(with: $0, options: .allowFragments)
                    as! [Any]
    }
    .subscribe(onNext:{
    data in
//    debugPrint("請求成功，回傳資料為：\(data)")
}) { (error) in
    debugPrint("請求失敗:\(error)")
}.disposed(by: disposeBag)

//使用RxSwift提供的rx.json來取得資料
URLSession.shared.rx.json(request: request).subscribe(onNext:{
    data in
    let json = data as! [Any]

//    debugPrint("請求成功，回傳資料為：\(json)")
}) { (error) in
    debugPrint("請求失敗:\(error)")
}.disposed(by: disposeBag)


//2 使用JSONDecoder
URLSession.shared.rx.data(request: request).subscribe(onNext:{
    data in

    let decoder = JSONDecoder()

    do {
        let json = try decoder.decode([WebAPIModelElement].self, from: data)
//        print("Json Result: \(json[0].title) \r\n\r\n")
//        print("Json JSONDecoder Result: \(json) \r\n\r\n")


    }
    catch let errorType
    {
        print("Json Parse 有錯誤: \(errorType.localizedDescription) \r\n\r\n")
        print("error: \(errorType) \r\n\r\n")
    }

}) { (error) in
    debugPrint("請求失敗:\(error)")
}.disposed(by: disposeBag)



private var jsonDecoder = JSONDecoder()
private var urlSession: URLSession

urlSession = URLSession(configuration: URLSessionConfiguration.default)

/*
 上面都是在說明搭配RxSwift的發出Http請求與需要JSON解析的基本用法
 但是現在想將基本用法包裝成Function要如何進行呢
 
 一樣是使用
 https://jsonplaceholder.typicode.com/posts
 的資料做測試
 */


// ----fetchCallAPI0
//1 發出請求後，回傳JSON解析後的WebAPIModelElement的類別Model
func fetchCallAPI0(request: URLRequest) -> Observable<[WebAPIModelElement]> {

    //簡單的建立觀察者的方法
    return Observable.create { observer -> Disposable in
        
        //使用原生URLSession Task發出發出請求
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in

            guard let data = data else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return
            }

            do {
                //確定有取得資料，將其進行解析
                let albums = try JSONDecoder().decode([WebAPIModelElement].self, from: data)
                //進入onNext觀察者
                observer.onNext(albums)
            } catch {
                //進入onError觀察者
                observer.onError(error)
            }
        }
        task.resume()
        //request發完
        return Disposables.create{
            task.cancel()
        }
    }
}


//訂閱方法就可以進行發出請求
//但是解析出來的形式是固定的，並不能套用在其他JSON格式上
fetchCallAPI0(request: request).subscribe { (data) in
//    debugPrint("fetchCallAPI Json Data:\(data)")

} onError: { (error) in
    debugPrint("onError:\(error)")
} onCompleted: {
    debugPrint("onCompleted")
}.disposed(by: disposeBag)
// ----fetchCallAPI0

// ----fetchCallAPI1
//2 發出請求後，回傳JSON解析後這次改使用泛形Model
func fetchCallAPI1<T: Decodable>(request: URLRequest) -> Observable<T> {

    return Observable.create { observer -> Disposable in

        let task = URLSession.shared.dataTask(with: request) { data, _, _ in

            guard let data = data else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return
            }

            do {
                //這裡的JSON解析格式改用泛形，所以並不會事先進行解析，直到訂閱後由訂閱者進行解析
                let albums = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(albums)
            } catch {
                observer.onError(error)
            }
        }
        task.resume()
        return Disposables.create{
            task.cancel()
        }
    }
}

//訂閱方法就可以進行發出請求
//JSON的解析會在訂閱後，由訂閱者進行轉型，所以解析的彈性和使用的範圍就會比較廣
fetchCallAPI1(request: request).subscribe(
onNext: {
    (data :[WebAPIModelElement]) in
    debugPrint("fetchCallAPI1 Json Data:\(data)")
//    PlaygroundPage.current.finishExecution()
}, onError: {
    error in
    debugPrint("onError:\(error)")
//    PlaygroundPage.current.finishExecution()
}, onCompleted: {
    debugPrint("onCompleted")
//    PlaygroundPage.current.finishExecution()
}).disposed(by: disposeBag)

// ----fetchCallAPI1





// ----fetchCallAPI2
//除了使用泛型外也增加Status Code狀態的判斷
//這裡除了原本的URLRequest 再加入兩個不同Json格式的URL來證實泛型是有用的
let url1 = URL(string: "https://jsonplaceholder.typicode.com/users/1")!
var request1 = URLRequest(url: url1)

struct UserModel: Codable {
    let id: Int
    let name, username, email: String
    let address: AddressModel
    let phone, website: String
    let company: CompanyModel
}

struct AddressModel: Codable {
    let street, suite, city, zipcode: String
    let geo: GeoModel
}

struct GeoModel: Codable {
    let lat, lng: String
}

struct CompanyModel: Codable {
    let name, catchPhrase, bs: String
}

let url2 = URL(string: "https://fakestoreapi.com/products/1")!
var request2 = URLRequest(url: url2)

struct ProductModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let welcomeDescription, category: String
    let image: String
    let rating: RatingModel

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case welcomeDescription = "description"
        case category, image, rating
    }
}

struct RatingModel: Codable {
    let rate: Double
    let count: Int
}


public func fetchCallAPI2<T: Decodable>(request: URLRequest)
-> Observable<T> {
    
    //MARK: 建立一個觀察者
    return Observable.create { observer in
        
        //MARK: 建立一個URLSession dataTask
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                
                do {
                    let _data = data ?? Data()
                    //如果HTTP statusCode是正常的就進行Json的解析
                    if (200...399).contains(statusCode) {
                        let objs = try jsonDecoder.decode(T.self, from: _data)
                        //MARK: observer onNext event
                        observer.onNext(objs)
                    }
                    else {
                        //MARK: observer onError event
                        observer.onError(error!)
                    }
                } catch {
                    //MARK: observer onError event
                    observer.onError(error)
                }
            }
            //MARK: observer onCompleted event
            observer.onCompleted()
        }
        task.resume()
        //MARK: return our disposable
        return Disposables.create {
            task.cancel()
        }
    }
}

//與上面的方式不同，可以在宣告訂閱者指定型別，所以解析的彈性和使用的範圍就會比較廣

let postObservable:Observable<[WebAPIModelElement]> = fetchCallAPI2(request: request)

postObservable.subscribe { (model) in
    print("----------PostModel----------")
    print("PostModel:",model)

} onError: { (error) in
    print("error:",error)
}.disposed(by: disposeBag)


let userObservable: Observable<UserModel> = fetchCallAPI2(request: request1)

userObservable.subscribe { (model) in
    print("----------UserModel----------")
    print("UserModel:",model)

} onError: { (error) in
    print("error:",error)
}.disposed(by: disposeBag)

let productObservable: Observable<ProductModel> = fetchCallAPI2(request: request2)

productObservable.subscribe { (model) in
    print("----------ProductModel----------")
    print("ProductModel:",model)

} onError: { (error) in
    print("error:",error)
}.disposed(by: disposeBag)

// ----fetchCallAPI2
