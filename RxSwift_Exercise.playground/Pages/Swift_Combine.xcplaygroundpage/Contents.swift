import Foundation
import PlaygroundSupport
import Combine
import UIKit
import RxSwift

//NotificationCenter 一般做法
//var notificationToken:NSObjectProtocol
//
//notificationToken = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: { _ in
//
//    if UIDevice.current.orientation == .portrait {
//        print("Orientation changed to portrait")
//    }
//})
//
//
////NotificationCenter 結合Combine的做法
//var cancellable0:Cancellable?
//
//cancellable0 = NotificationCenter.default
//    .publisher(for: UIDevice.orientationDidChangeNotification)
//    .filter({ _ in
//        UIDevice.current.orientation == .portrait
//    })
//    .sink(){ _ in print("Orientation changed to portrait")}
//
//
//
////Timer 一般做法
//var timer:Timer?
//
//timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//    DispatchQueue.main.async {
//        print("Update Date")
//    }
//})
//
//
////Timer 結合Combine的做法
var cancellable1:AnyPublisher<Date, Never>?

cancellable1 = Timer.publish(every: 1, on: RunLoop.main, in: .common)
    .print()
    .eraseToAnyPublisher()

//let justPubliser = Just("Hello")
//
//let justPubliser1 = Combine.Just("Hello Again")
//let justPubliser2 = Combine.Empty<Any, Error>()
//let justPubliser3 = Combine.Fail<Any, Error>(error: Error.self as! Error)


class Student {
    let name: String
    var score: Int

    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

let student = Student(name: "Jack", score: 90)
print(student.score)
let observer = Subscribers.Assign(object: student, keyPath: \Student.score)
let publisher = PassthroughSubject<Int, Never>()
publisher.subscribe(observer)
publisher.send(91)
print(student.score)
publisher.send(100)
print(student.score)

let url = URL(string: "")!

let apiRequest = Future<Data?, Never> { promise in
    URLSession.shared.dataTask(with: url) { data, _, _ in
        promise(.success(data))
    }.resume()
}

let request = URLRequest(url:URL(string: "")!)
let file = URL(string: "")!
let downloadPublisher = Future<Data?, Never> { promise in
    URLSession.shared.uploadTask(with: request, fromFile: file) { (data, _, _) in
        promise(.success(data))
    }.resume()
}

let cancellable = downloadPublisher.sink { data in
    print("Received data: \(data)")
}

// Cancel the task before it finishes
cancellable.cancel()


PlaygroundPage.current.finishExecution()
