
import Foundation
import RxSwift
import RxCocoa

//Debug Operators
let disposeBag = DisposeBag()

//debug
debugPrint("--------debug---------")
//debug方法可以協助開發者將所有訂閱者、事件和處理等資訊全部列印出來

Observable.of("2", "3")
    .startWith("1")
    .debug("執行1")
    .subscribe(onNext: { debugPrint($0) })
    .disposed(by: disposeBag)

//RxSwift.Resources.total
debugPrint("--------RxSwift.Resources.total---------")
debugPrint("RxSwift.Resources.total0:",RxSwift.Resources.total)

let subject = BehaviorSubject(value: "Maxiaoliao")

let subscription1 = subject.subscribe(onNext: { debugPrint($0) })

debugPrint("RxSwift.Resources.total1:",RxSwift.Resources.total)

let subscription2 = subject.subscribe(onNext: { debugPrint($0) })

debugPrint("RxSwift.Resources.total2:",RxSwift.Resources.total)

subscription1.dispose()

debugPrint("RxSwift.Resources.total3:",RxSwift.Resources.total)

subscription2.dispose()

debugPrint("RxSwift.Resources.total4:",RxSwift.Resources.total)

