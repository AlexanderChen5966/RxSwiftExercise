import Foundation
import RxSwift
import RxCocoa

//Mathematical and Aggregate Operators
let disposeBag = DisposeBag()


//toArray
//toArray可以將一個序列轉成一個陣列，並當成一個單一事件發送並結束
debugPrint("------toArray-------")
Observable.of(1, 2, 3)
    .toArray()
    .subscribe({ debugPrint($0) })
    .disposed(by: disposeBag)


//reduce
//reduce接受一個初始值和操作符號
//將初始值與序列當中的每個值進行累計運算，並將總計結果發送出去
Observable.of(1, 2, 3, 4, 5)
    .reduce(0, accumulator: +)
    .subscribe({ debugPrint($0) })
    .disposed(by: disposeBag)

//concat
//concat可以把多個Observable序列合併成一個Observable序列
//當前一個Observable序列(subject1)發出completed事件，才會發送下一個Observable序列(subject2)的事件
let subject1 = BehaviorSubject(value: 1)
let subject2 = BehaviorSubject(value: 2)

let behaviorRelay = BehaviorRelay(value: subject1)
behaviorRelay
    .concat()
    .subscribe({ debugPrint($0) })
    .disposed(by: disposeBag)

subject2.onNext(2)
subject1.onNext(4)
subject1.onNext(5)
subject1.onCompleted()

behaviorRelay.accept(subject2)
subject2.onNext(8)



