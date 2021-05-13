import Foundation
import RxSwift
import RxCocoa


//Conditional and Boolean Operators

//amb
//當傳入多個Observables到amb時，將取第一個發出事件的Observable，並且只發出該Observable的元素，忽略其他Observable，下面的例子第一個為subject2，所以subject1、subject3則忽略
debugPrint("------amb-------")

let disposeBag = DisposeBag()
let subject1 = PublishSubject<Int>()
let subject2 = PublishSubject<Int>()
let subject3 = PublishSubject<Int>()

subject1
    .amb(subject2)
    .amb(subject3)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

subject2.onNext(1)//
subject1.onNext(20)
subject2.onNext(2)//
subject1.onNext(40)
subject3.onNext(0)
subject2.onNext(3)//
subject1.onNext(60)
subject3.onNext(0)
subject3.onNext(0)


//takeWhile
//takeWhile會依次判斷Observable Queue的每一個值是否滿足設定的條件，當"第一個不滿足"的值出現時完成

debugPrint("------takeWhile-------")
Observable.of(2, 3, 1 ,4, 2, 6)
    .takeWhile { $0 < 4 }
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

//takeUntil
//takeUntil除了監控原本的source Observable，還可以監控另一個Observable 以下面的範例即為notifier
//直到notifier發出值或是complete通知，source的Observable就會完成並結束
debugPrint("------takeUntil-------")

let source = PublishSubject<String>()
let notifier = PublishSubject<String>()

source
    .takeUntil(notifier)
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)

source.onNext("a")
source.onNext("b")
source.onNext("c")
source.onNext("d")

//停止接收訊息
notifier.onNext("z")

source.onNext("e")
source.onNext("f")
source.onNext("g")

//skipWhile
//skipWhile會跳過前面滿足條件的事件
//一旦不滿足的事件出現，就不會在跳過(所以1明明小於4，還是print出來)
debugPrint("------skipWhile-------")
Observable.of(2, 3, 4, 5, 1, 6)
    .skipWhile { $0 < 4 }
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)



//skipUntil
//skipUntil與takeUntil一樣，除了source1 Observable，還可以監控另一個Observable 以下面的範例即為notifier1
//與takeUntil相反的是，source1 Observable事件會一直跳過，直到notifier1發出值或是complete通知，才開始發出通知
debugPrint("------skipUntil-------")

let source1 = PublishSubject<Int>()
let notifier1 = PublishSubject<Int>()

source1
    .skipUntil(notifier1)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

source1.onNext(1)
source1.onNext(2)
source1.onNext(3)
source1.onNext(4)
source1.onNext(5)

//開始接收通知
notifier1.onNext(0)
source1.onNext(6)
source1.onNext(7)
source1.onNext(8)

//仍然接收通知
notifier1.onNext(0)

source1.onNext(9)
