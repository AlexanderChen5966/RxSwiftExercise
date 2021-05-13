import Foundation
import RxSwift
import RxCocoa

//Combining Observables
let disposeBag = DisposeBag()

//startWith
//startWith可以在Observable Queue開始前插入一些事件元素，會先發出這些預先插入的事件訊息

debugPrint("------startWith-------")
Observable.of("2", "3")
    .startWith("4","8")
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

debugPrint("------startWith多筆-------")

Observable.of("2", "3")
    .startWith("a")
    .startWith("b")
    .startWith("c")
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


//merge
//merge可以將多個(兩個或兩個以上)Observable Queue合併成一個Observable Queue
debugPrint("------merge-------")

let subject1 = PublishSubject<Int>()
let subject2 = PublishSubject<Int>()

Observable.of(subject1, subject2)
    .merge()
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

subject1.onNext(20)
subject1.onNext(40)
subject1.onNext(60)
subject2.onNext(1)
subject1.onNext(80)
subject1.onNext(100)
subject2.onNext(1)

//zip
//zip可以將多個(兩個或兩個以上)Observable Queue"壓縮"成一個Observable Queue
//zip會把事件一一湊成對後再合併，無法湊成對則忽略

debugPrint("------zip-------")
let subject3 = PublishSubject<Int>()
let subject4 = PublishSubject<String>()

Observable.zip(subject3, subject4) {
    "\($0)\($1)"
    }
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

subject3.onNext(1)
subject4.onNext("A")
subject3.onNext(2)
subject4.onNext("B")
subject4.onNext("C")
subject4.onNext("D")
subject3.onNext(3)
subject3.onNext(4)
subject3.onNext(5)
subject3.onNext(6)
subject3.onNext(7)
subject4.onNext("E")

//debugPrint("------zip應用案例-------")
//例如我們想同時發兩個Request，當兩個Request都成功後，將結果整合再繼續往下處理，就可以使用zip來完成
//第一個Request
//let userRequest: Observable<User> = API.getUser("me")

//第二個Request
//let friendsRequest: Observable<Friends> = API.getFriends("me")

//將兩個Request壓縮處理
//Observable.zip(userRequest, friendsRequest) {
//    user, friends in
//    //將兩個事件合併成一個事件，并壓縮成一個元組返回（兩個事件均成功）
//    return
//    }
//    .observeOn(MainScheduler.instance) //加這個是因為Request在後端線程，下面的綁定在前端線程。
//    .subscribe(onNext: { (user, friends) in
//    //將資訊綁定到界面上
//    //.......
//    })
//    .disposed(by: disposeBag)

//combineLatest
//combineLatest與merge、zip一樣，可以將多個(兩個或兩個以上)Observable Queue合併成一個Observable Queue
//與zip不同的是，每當任意一個Observable發出新的事件時，會將"每個"Observable Queue的最新的一個事件元素進行合併

debugPrint("------combineLatest-------")

let subject5 = PublishSubject<Int>()
let subject6 = PublishSubject<String>()

Observable.combineLatest(subject5, subject6) {
    "\($0)\($1)"
    }
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

subject5.onNext(1)
subject6.onNext("A")
subject5.onNext(2)
subject6.onNext("B")
subject6.onNext("C")
subject5.onNext(3)
subject5.onNext(4)
subject6.onNext("D")
subject5.onNext(5)


//withLatestFrom
//withLatestFrom同樣可以將兩個Observable Queue合併成一個Observable Queue
//每當subject7的queue發送一個事件，便從第二個queue中取一個最新的值
debugPrint("------withLatestFrom-------")

let subject7 = PublishSubject<String>()
let subject8 = PublishSubject<String>()

subject7.withLatestFrom(subject8)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

subject7.onNext("A")
subject8.onNext("1")
subject7.onNext("B")
subject7.onNext("C")
subject8.onNext("2")
subject7.onNext("D")


//switchLatest
//switchLatest有點像switch方法，可以對事件流進行轉換
//比如本來監聽的 subject9，透過更改behaviorRelay accept方法更換事件源。變成監聽subject10
debugPrint("------switchLatest-------")
let subject9 = BehaviorSubject(value: "A")
let subject10 = BehaviorSubject(value: "1")

let behaviorRelay = BehaviorRelay(value: subject9)
behaviorRelay
    .switchLatest()
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

//let variable = Variable(subject9)
//
//variable.asObservable()
//    .switchLatest()
//    .subscribe(onNext: { debugPrint($0) })
//    .disposed(by: disposeBag)
    
subject9.onNext("B")
subject9.onNext("C")
    
//改變事件源
//variable.value = subject10
behaviorRelay.accept(subject10)

subject9.onNext("D")
subject10.onNext("2")

//改變事件源
//variable.value = subject9
behaviorRelay.accept(subject9)

subject10.onNext("3")
subject9.onNext("E")
