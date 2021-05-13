import Foundation
import RxSwift
import RxCocoa

//Connectable Observable Operators
let disposeBag = DisposeBag()

//Connectable Observable
//Connectable Observable與一般Observable不同的地方於，有訂閱時不會立刻發出事件，直到執行connect()後才會開始發送事件
//Connectable Observable可以讓所有訂閱者訂閱之後才開始發送事件，確保我們期望的所有訂閱者都收到事件
debugPrint("--------Connectable Observable---------")


//一般序列
///延遲執行
/// - Parameters:
///   - delay: 延遲時間（秒）
///   - closure: 延遲執行的閉包
public func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

//let interval = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
//_ = interval.subscribe(onNext:{ debugPrint("訂閱1:\($0)")})
//delay(5) {
//    _ = interval.subscribe(onNext:{ debugPrint("訂閱2:\($0)")})
//
//}
//兩個訂閱結果不同步

//publish
debugPrint("--------publish---------")

//publish方法會將一個正常的序列轉換成可連結的序列。
//同時該序列不會立刻發送事件，需要等待connect執行後才會開始發送訊息。

//每隔1秒會發送1個事件
let publishInterval = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).publish()
//第一個訂閱者(立刻開始執行)
_ = publishInterval.subscribe(onNext:{ debugPrint("訂閱3:\($0)")})

//相當於把事件延遲2秒
//delay(2) {
//    _ = publishInterval.connect()//2秒後才開始執行
//}

//第二個訂閱者(延遲5秒開始訂閱)
delay(5) {
    //這裡的延遲5秒(=2+3秒)與上面的延遲2秒同步計算
    _ = publishInterval.subscribe(onNext:{ debugPrint("訂閱4:\($0)")})
}

//replay
debugPrint("--------replay---------")
//replay與publish方法一樣，會將一個正常的序列轉換成可連結的序列。同樣也是等待connect執行後才會開始發送訊息
//replay與publish不同的地方在新的訂閱者還是能接收到訂閱之前的事件(數量由bufferSize決定)
let replyInterval = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).replay(5)

_ = replyInterval.subscribe(onNext:{ debugPrint("訂閱5:\($0)")})

//delay(2) {
//    _ = replyInterval.connect()
//}
delay(5) {
    _ = replyInterval
        .subscribe(onNext: { debugPrint("訂閱6:\($0)") })
}

//multicast
debugPrint("--------multicast---------")
//multicast 與replay、publish方法一樣，會將一個正常的序列轉換成可連結的序列。同樣也是等待connect執行後才會開始發送訊息
//同時multicast還可以傳入一個Subjuct，每當序列發送事件時都會觸發Subjuct的發送

let subject1 = PublishSubject<Int>()

_ = subject1.subscribe(onNext:{ debugPrint("Subject:\($0)") })

//每隔1秒會發送1個事件
let multicastInterval = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    .multicast(subject1)

_ = multicastInterval.subscribe(onNext:{ debugPrint("訂閱7:\($0)") })

//delay(2) {
//    _ = multicastInterval.connect()
//}

delay(5) {
    _ = multicastInterval.subscribe(onNext:{ debugPrint("訂閱8:\($0)") })
}

//refCount
debugPrint("--------refCount---------")
//refCount可以將被連接的Observable轉換成普通的Observable
//refCount可以自動連結或斷開可連接的Observable。當第一個觀察者對可訂閱的Observable訂閱時，那麼底層的Observable將被自動連接，當最後一個觀察者離開時自動斷開連結
//refcount會自動執行connect方法
//let refCountInterval = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).publish().refCount()
//
//
//let firstSubscribe = refCountInterval.subscribe(onNext:{ debugPrint("訂閱9:\($0)") })
//
//delay(5) {
//    _ = refCountInterval.subscribe(onNext:{ debugPrint("訂閱10:\($0)") })
//}
//
//
//delay(8) {
//    debugPrint("dispose at 8 seconds")
//    firstSubscribe.dispose()
//}



//share(relay:)
debugPrint("--------share(relay:)---------")
//觀察者共享同一個Observable，並暫存最新的n個元素，將這些元素發送給新的觀察者
//shareReplay就是replay和refCount的組合
let shareInterval = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).share(replay: 5)

_ = shareInterval.subscribe(onNext:{ debugPrint("訂閱11:\($0)") })

delay(5) {
    _ = shareInterval.subscribe(onNext:{ debugPrint("訂閱12:\($0)") })
}


