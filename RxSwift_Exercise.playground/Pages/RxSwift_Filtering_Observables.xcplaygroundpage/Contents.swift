import Foundation
import RxSwift
import RxCocoa
//Filtering Observables

debugPrint("------filter-------")
let disposeBag = DisposeBag()
Observable.of(2,30,22,5,60,3,40,9)
    .filter {
    $0 > 10
    }
    .subscribe(onNext:{ debugPrint($0) })
    .disposed(by: disposeBag)



debugPrint("------distinctUntilChanged-------")
//過濾連續重複的事件
Observable.of(1, 2, 2, 3, 1, 1, 4)
    .distinctUntilChanged()
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

debugPrint("------single-------")
//限制只能發送一次事件，或是滿足條件的第一個事件
//存在有多個事件成立或是沒有事件成立都會發出一個Error
//只有一個事件，則不會發出error事件

Observable.of(1,2,3,4)
    .single{ $0 == 2}
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

Observable.of("A","B","C","D")
    .single{ $0 == "C"}
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

debugPrint("------element-------")
//只處理指定位置的事件

Observable.of(1, 2, 3, 4)
    .elementAt(2)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


debugPrint("------ignoreElements-------")
//忽略所有元素，只發出error或completed事件
//如果我們並不關心 Observable 的任何元素，只想知道 Observable 在什麼時候停止，那就可以使用 ignoreElements
Observable.of(1, 2, 3, 4)
    .ignoreElements()
    .subscribe{ debugPrint($0) }
    .disposed(by: disposeBag)


debugPrint("------take-------")
//發送至前面數來第n個事件，滿足後停止
Observable.of(1, 2, 3, 4)
    .take(2)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


debugPrint("------takeLast-------")
//發送至後面數來第n個事件，滿足後停止
Observable.of(5, 6, 7, 8)
    .takeLast(1)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


debugPrint("------skip-------")
//跳過前面數來第n個事件
Observable.of(9, 10, 11, 12)
    .skip(2)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


debugPrint("------sample-------")
//除了訂閱source Observable之外，還可以監控另一個notifier的Observable
//每當收到notifier事件，就會從source的queue取一個最新的事件發送，如果兩次notifier事件之間沒有source的事件，則不發送
let source = PublishSubject<Int>()
let notifier = PublishSubject<String>()

source
    .sample(notifier)
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)


source.onNext(1)

//讓source佇列接收消息
notifier.onNext("A")

source.onNext(2)

//讓source佇列接收消息
notifier.onNext("B")
notifier.onNext("C")

source.onNext(3)
source.onNext(4)

//讓source佇列接收消息
notifier.onNext("D")

source.onNext(5)

//讓source佇列接收消息
notifier.onCompleted()


debugPrint("------debounce-------")
//過濾高頻率產生的元素，元素產生後，一段時間內沒有新元素產生之元素
//也就是說 Queue中的元素如果和下一個元素的間隔"小於等於"指定的時間間隔，那麼元素將被過濾掉
//常用在使用者輸入的時候，不需要每個文字輸入進去都發送一個事件，而是稍等一下取最後一個事件

//定義每個事件的值與發送時間
let times = [
            [ "value": 1, "time": 100 ],
            [ "value": 2, "time": 2700 ],
            [ "value": 3, "time": 1200 ],
            [ "value": 4, "time": 3500 ],
            [ "value": 5, "time": 1400 ],
            [ "value": 6, "time": 2100 ]
        ]
        //生成對應的 Observable Queue並訂閱
        Observable.from(times)
            .flatMap { item in
                
                
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(RxTimeInterval.milliseconds(Int(item["time"]!)),
                                                       scheduler: MainScheduler.instance)

            }
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance) //只發出與下一元素間隔"超過"0.5秒的元素(剛好0.5秒則跳過)
            .subscribe(onNext: { debugPrint($0) })
            .disposed(by: disposeBag)


