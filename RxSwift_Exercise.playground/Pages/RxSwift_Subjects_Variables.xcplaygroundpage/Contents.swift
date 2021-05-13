import Foundation
import RxSwift
import RxCocoa

//Subject


//PublishSubject
let disposeBag = DisposeBag()
let publicSubject = PublishSubject<String>()

//由於目前沒有任何訂閱者，所以111的訊息不會輸出到Console
publicSubject.onNext("111")

//第1次訂閱
publicSubject.subscribe { (string) in
    debugPrint("第1次訂閱：", string)
}  onCompleted: {
    debugPrint("第1次訂閱： onCompleted")
}.disposed(by: disposeBag)

//目前有一個訂閱，會輸出在Console
publicSubject.onNext("222")

//第2次訂閱
publicSubject.subscribe { (string) in
    debugPrint("第2次訂閱：", string)
}  onCompleted: {
    debugPrint("第2次訂閱： onCompleted")
}.disposed(by: disposeBag)


//目前第二個訂閱，會輸出在Console
publicSubject.onNext("333")

//讓訂閱事件結束
publicSubject.onCompleted()

publicSubject.onNext("444")

//第3次訂閱
publicSubject.subscribe { (string) in
    debugPrint("第3次訂閱：", string)
}  onCompleted: {
    debugPrint("第3次訂閱： onCompleted")
}.disposed(by: disposeBag)



//----
debugPrint("------------")


//BehaviorSubject
let behaviorSubject = BehaviorSubject(value: "111")

//第1次訂閱
behaviorSubject.subscribe{
    event in
    debugPrint("第1次訂閱：",event)
}.disposed(by: disposeBag)


behaviorSubject.onNext("222")

behaviorSubject.onError(NSError(domain: "local", code: 0, userInfo: nil))
//behaviorSubject.onCompleted()
behaviorSubject.subscribe { event in
    debugPrint("第2次訂閱：", event)
}.disposed(by: disposeBag)

debugPrint("------ReplaySubject------")

//ReplaySubject
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

//連續發3次事件
replaySubject.onNext("111")
replaySubject.onNext("222")
replaySubject.onNext("333")


replaySubject.subscribe { event in
    debugPrint("第1次訂閱：", event)
}.disposed(by: disposeBag)

replaySubject.onNext("444")

replaySubject.subscribe { event in
    debugPrint("第2次訂閱：", event)
}.disposed(by: disposeBag)

replaySubject.onCompleted()

replaySubject.subscribe { event in
    debugPrint("第3次訂閱：", event)
}.disposed(by: disposeBag)


debugPrint("------BehaviorRelay------")

//----------------
//Variable已經無法使用，用BehaviorRelay取代
//BehaviorRelay
let behaviorRelaySubject = BehaviorRelay<String>(value: "111")
behaviorRelaySubject.accept("222")

//behaviorRelaySubject.asObservable().subscribe{
//    debugPrint("第1次訂閱：",$0)
//}.disposed(by: disposeBag)

behaviorRelaySubject.subscribe{
    debugPrint("第1次訂閱：",$0)
}.disposed(by: disposeBag)


behaviorRelaySubject.accept("333")
behaviorRelaySubject.asObservable().subscribe{
    debugPrint("第2次訂閱：",$0)
}.disposed(by: disposeBag)
behaviorRelaySubject.accept("444")

debugPrint("------BehaviorRelay Array------")


let behaviorRelayArraySubject = BehaviorRelay<[String]>(value: ["1"])
behaviorRelayArraySubject.accept(behaviorRelayArraySubject.value + ["2", "3"])
behaviorRelayArraySubject.subscribe{
    debugPrint("第1次訂閱：",$0)
}.disposed(by: disposeBag)

behaviorRelayArraySubject.accept(behaviorRelayArraySubject.value + ["4","5"])

behaviorRelayArraySubject.subscribe{
    debugPrint("第2次訂閱：",$0)
}.disposed(by: disposeBag)


behaviorRelayArraySubject.accept(behaviorRelayArraySubject.value + ["6","7"])
