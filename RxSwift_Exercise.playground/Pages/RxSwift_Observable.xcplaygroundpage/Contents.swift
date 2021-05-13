import Foundation
import RxSwift
//https://www.hangge.com/blog/cache/detail_1924.html

//:## Observable 可以發出三種不同的Event事件

/*:### next
 - next 事件就是可以攜帶數據<T>的事件，可以說它就是一個"最正常"的事件
 */

/*: ### error
 - error事件表示一個錯誤，它可以攜帶具體的錯誤內容，一旦Observable發出了error event，則這個Observable就等於終止了，以後它再也不會發出event事件了
 */

/*:### completed
 - completed事件表示Observable發出的事件正常地結束了，跟error一樣，一旦Observable發出了completed event，則這個Observable就等於終止了，以後它再也不會發出event事件了。
 */


//:## 建立Observables

//:使用just()，可以簡單的生成只有一個元素的Observable
let justObservable = Observable<Int>.just(5)

//:使用of()，接收多個元素生成一個Observable
let ofObservable = Observable.of("A", "B", "C")

//:使用of()，接收一個陣列並生成一個Observable
let fromObservable = Observable.from([1,2,3])

//:使用empty()，生成一個0個元素的Observable，只會觸發completed的事件，並不會觸發其他事件
let emptyObservable = Observable<Void>.empty()

//:使用never()，生成的Observable不會觸發next、completed事件
let neverObservable = Observable<Any>.never()

//:使用create，生成Observable，需要傳入一個參數observer，並返回一個Disposable的閉包，並在閉包中定義完所有將發送的事件

let createObservable = Observable<String>.create { observer in
    // 1 發出一個字串1的next事件
    observer.onNext("1")
    // 2 發出completed事件
    observer.onCompleted()
    // 3 由於completed事件已發出，所以onNext("?")事件並不會進入序列中
    observer.onNext("?")
    // 4 生成Observable
    return Disposables.create()

}


//:## 訂閱Observables

//使用上面create的Observable，再透過subscribe去訂閱Observable，可以取得Observable所設定的事件
createObservable.subscribe{
    event in
    switch event {
    case .next(let value):
        debugPrint("createObservable value is \(value)")
    case .completed:
        debugPrint("completed")
    case .error(let error):
        debugPrint("error message \(error)")
    }
}.dispose()

//接著使用ofObservable，顯示兩種subscribe的樣式
//樣式1
/*
 subscribe{ event in
     switch event {
     case.next(let string):
         if string == "A" {
             debugPrint("is A")
         }

     case.error(let error):
         debugPrint("error message \(error)")

     case.completed:
         debugPrint("completed")

     }
 }
 */
ofObservable.subscribe{ event in
//    debugPrint("ofObservable -> " ,event)
    switch event {
    case.next(let string):
        if string == "A" {
            debugPrint("is A")
        }

    case.error(let error):
        debugPrint("error message \(error)")

    case.completed:
        debugPrint("completed")

    }
}.dispose()


//ofObservable.subscribe{
//    event in
//    if event.element == nil {
//        return
//    }
//    debugPrint(event.element)
//
//}


//樣式2
/*
 subscribe(onNext: {
     element in
     if element == "A" {
         debugPrint("is A")
     }

 }, onError: {
     error in
    debugPrint("error message \(error)")

 }, onCompleted: {
    debugPrint("completed")

 }, onDisposed: {
    debugPrint("disposed")

 })
 */
ofObservable.subscribe(onNext: {
    element in
    if element == "A" {
        debugPrint("is A")
    }else {
        debugPrint("Other Event \(element)")
    }

}, onError: {
    error in
    debugPrint("error message \(error)")

}, onCompleted: {
    debugPrint("completed")

}, onDisposed: {
    debugPrint("disposed")

}).dispose()


//ofObservable.subscribe { event in
//    debugPrint(event)
//} onError: { error in
//    debugPrint(error)
//} onCompleted: {
//    debugPrint("completed")
//} onDisposed: {
//    debugPrint("disposed")
//}

//也可以只使用需要的事件閉包
//ofObservable.subscribe(onNext: { element in
//    debugPrint(element)
//})



//監聽事件生命週期
ofObservable.do { (element) in
    debugPrint("do next:",element)
} afterNext: { (afterElement) in
    debugPrint("do afterNext:",afterElement)
} onError: { (error) in
    debugPrint("do error",error)
} afterError: { (afterError) in
    debugPrint("do after error",afterError)
} onCompleted: {
    debugPrint("do completed")
} afterCompleted: {
    debugPrint("do after completed")
} onSubscribe: {
    debugPrint("do subscribe")
} onSubscribed: {
    debugPrint("do subscribed")
} onDispose: {
    debugPrint("dispose")
}
.subscribe { event in
    debugPrint(event)
} onError: { error in
    debugPrint(error)
} onCompleted: {
    debugPrint("subscribe completed")
} onDisposed: {
    debugPrint("subscribe disposed")
}

//:## 取消訂閱 Observable
// 如果不取消訂閱，將可能發生memory leak
//Observable的銷毀（Dispose）
let subscription = ofObservable.subscribe { event in
    print(event)
}

//呼叫訂閱的dispose()方法，就可以取消訂閱
subscription.dispose()

//當然也可以將dispose另外抽出來寫
let disposeBag = DisposeBag()
let observable1 = Observable.of("A", "B", "C")
observable1.subscribe { event in
    print(event)
}.disposed(by: disposeBag)

let observable2 = Observable.of(1, 2, 3)
observable2.subscribe { event in
    print(event)
}.disposed(by: disposeBag)
