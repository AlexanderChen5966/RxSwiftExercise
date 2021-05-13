import Foundation
import RxSwift
import RxCocoa

//Observable Utility Operators
let disposeBag = DisposeBag()


//delay
debugPrint("--------delay---------")
//將Observable所有的元素延遲到設定的時間後再發送出去


//Observable.of(1, 2, 3)
//    .delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext:{  debugPrint($0)})
//    .disposed(by: disposeBag)


//delaySubscription
debugPrint("--------delaySubscription---------")
//delaySubscription用來做延遲訂閱，經過設定的時間後才進行訂閱操作
//Observable.of(4, 5, 6)
//    .delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext:{ debugPrint($0) })
//    .disposed(by: disposeBag)



//materialize
debugPrint("--------materialize---------")
//materialize可以將序列產生的事件轉換成元素
//一個Observable會產生0個或多個onNext事件，最後產生一個onCompleted或者onError事件，materialize方法會將Observable產生的事件全部轉換成元素然後送出。
Observable.of(7, 8, 9)
    .materialize()
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)

//dematerialize
debugPrint("--------dematerialize---------")
//dematerialize與materialize相反，可以將轉換後的元素還原
Observable.of(7, 8, 9)
    .materialize()
    .dematerialize()
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)


//timeout
debugPrint("--------timeout---------")
//一段時間沒有發出任何元素，就會產生一個超時的error

let times = [
    [ "value": 1, "time": 0 ],
    [ "value": 2, "time": 500 ],
    [ "value": 3, "time": 1600 ],
    [ "value": 4, "time": 400 ],
    [ "value": 5, "time": 500 ]
]
//Observable.from(times).flatMap{
//    item in
//    return Observable.of(Int(item["value"]!)).delaySubscription(RxTimeInterval.milliseconds(Int(item["time"]!)),scheduler: MainScheduler.instance)
//}
//.timeout(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
//.subscribe(onNext:{
//    debugPrint($0)
//}, onError: {
//    error in
//    debugPrint(error)
//
//})
//.disposed(by: disposeBag)

//using
debugPrint("--------using---------")
//使用using建立Observable時，同時會建立一個被清除的資源，一旦Observable終止，該資源也會被清除掉

class AnyDisposable: Disposable {
    let _dispose: () -> Void
    
    init(_ disposable: Disposable) {
        _dispose = disposable.dispose
    }
    
    func dispose() {
        _dispose()
    }
}

//無限序列(每0.1秒建立一個序列)
let infiniteInterval = Observable<Int>.interval(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
    .do(
        onNext:{ debugPrint("infinite: \($0)")},
        onSubscribe: { debugPrint("開始訂閱 infinite")},
        onDispose: {debugPrint("銷毀 infinite")  }
    )

//有限序列(每0.5秒建立一個序列，共建立三個)
let limited = Observable<Int>.interval(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
    .take(2)
    .do(
        onNext:{ debugPrint("limited: \($0)")},
        onSubscribe: { debugPrint("開始訂閱 limited")},
        onDispose: {debugPrint("銷毀 limited")  }
    )

//使用using建立序列
let o: Observable<Int> = Observable.using { () -> AnyDisposable in
    return AnyDisposable(infiniteInterval.subscribe())
} observableFactory: { _ in return limited }

o.subscribe()
