import Foundation
import RxSwift
import RxCocoa
//Transforming Observables



//1.buffer
let disposeBag = DisposeBag()
let publishSubject = PublishSubject<String>()

//publishSubject.buffer(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        debugPrint($0)
//    })
//    .disposed(by: disposeBag)
//publishSubject.onNext("a")
//publishSubject.onNext("b")
//publishSubject.onNext("c")
//
//publishSubject.onNext("1")
//publishSubject.onNext("2")
//publishSubject.onNext("3")


//2.window
let windowSubject = PublishSubject<String>()

//windowSubject.window(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance).subscribe(onNext:{
//    debugPrint("subscribe: \($0)")
//    $0.asObservable().subscribe(onNext:{
//        debugPrint($0)
//    }).disposed(by: disposeBag)
//})
//.disposed(by: disposeBag)
//
//
//windowSubject.onNext("a")
//windowSubject.onNext("b")
//windowSubject.onNext("c")
//
//windowSubject.onNext("1")
//windowSubject.onNext("2")
//windowSubject.onNext("3")


//3.map
debugPrint("----Map----")
Observable.of(1, 2, 3)
    .map { $0 * 10}
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


debugPrint("----flatMap----")
let subject1 = BehaviorSubject(value: "A")
let subject2 = BehaviorSubject(value: "1")


let behaviorRelaySubject = BehaviorRelay(value: subject1)
behaviorRelaySubject
    .flatMap{ $0 }
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)
subject1.onNext("B")
behaviorRelaySubject.accept(subject2)
subject2.onNext("2")
subject1.onNext("C")


debugPrint("----flatMapLatest----")
let subject3 = BehaviorSubject(value: "A")
let subject4 = BehaviorSubject(value: "1")


let behaviorRelaySubject1 = BehaviorRelay(value: subject3)
behaviorRelaySubject1
    .flatMapLatest{ $0 }
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)
subject3.onNext("B")
behaviorRelaySubject1.accept(subject4)
subject4.onNext("2")
subject3.onNext("C")

//flatMapLast只會接收最新的事件(先subject3在subject4)
debugPrint("----flatMapFirst----")
let subject5 = BehaviorSubject(value: "A")
let subject6 = BehaviorSubject(value: "1")


let behaviorRelaySubject2 = BehaviorRelay(value: subject5)
behaviorRelaySubject2
    .flatMapFirst{ $0 }
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)
subject5.onNext("B")
behaviorRelaySubject2.accept(subject6)
subject6.onNext("2")
subject5.onNext("C")
//flatMapFirst只會接收最初的事件(subject5)

debugPrint("----concatMap----")
let subject7 = BehaviorSubject(value: "A")
let subject8 = BehaviorSubject(value: "1")


let behaviorRelaySubject3 = BehaviorRelay(value: subject7)
behaviorRelaySubject3
    .concatMap{ $0 }
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)
subject7.onNext("B")
behaviorRelaySubject3.accept(subject8)
subject8.onNext("2")
subject7.onNext("C")
subject7.onCompleted()//前一個序列(subject7)結束之後，才會開始接收下一個序列(subject8)

debugPrint("----scan----")
//先给一個初始化的值，然后不斷的拿前一個结果和最新的值進行處理
Observable.of(1, 2, 3, 4, 5)
    .scan(0) { acum, elem in
        acum + elem
    }
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

debugPrint("----groupBy----")
//將奇、偶數分成兩組
Observable<Int>.of(0, 1, 2, 3, 4, 5)
    .groupBy(keySelector: { (element) -> String in
        return element % 2 == 0 ? "偶數" : "奇數"
    })
    .subscribe { (event) in
        switch event {
        case .next(let group):
            group.asObservable().subscribe({ (event) in
                debugPrint("key：\(group.key)    event：\(event)")
            })
            .disposed(by: disposeBag)
        default:
            debugPrint("")
        }
    }
.disposed(by: disposeBag)
