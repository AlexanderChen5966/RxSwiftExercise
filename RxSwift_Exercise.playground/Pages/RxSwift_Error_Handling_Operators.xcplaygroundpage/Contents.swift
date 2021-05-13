import Foundation
import RxSwift
import RxCocoa

//Error Handling Operators
let disposeBag = DisposeBag()

enum MyError: Error {
    case A
    case B
}

//catchErrorJustReturn
debugPrint("--------catchErrorJustReturn---------")
//當遇到error事件時，就返回指定的參數然後結束
let sequenceThatFails = PublishSubject<String>()
sequenceThatFails
    .catchErrorJustReturn("catchErrorJustReturn錯誤")
    .subscribe(onNext:{  debugPrint($0)})
    .disposed(by: disposeBag)

sequenceThatFails.onNext("a")
sequenceThatFails.onNext("b")
sequenceThatFails.onNext("c")
sequenceThatFails.onError(MyError.A)
sequenceThatFails.onNext("d")

//catchError
debugPrint("--------catchError---------")
//catchError可以取得error，並進行相對應的處理
//同時返回另一個Observable進行訂閱
let catchErrorSequenceThatFails = PublishSubject<String>()
let recoverySequence = Observable.of("1", "2", "3")

catchErrorSequenceThatFails.catchError {
    debugPrint("catchError:",$0)
    return recoverySequence
}
.subscribe(onNext:{  debugPrint($0)})
.disposed(by: disposeBag)

catchErrorSequenceThatFails.onNext("a")
catchErrorSequenceThatFails.onNext("b")
catchErrorSequenceThatFails.onNext("c")
catchErrorSequenceThatFails.onError(MyError.A)
catchErrorSequenceThatFails.onNext("d")


//retry
debugPrint("--------retry---------")
//retry當遇到error時，重新訂閱該序列，如網路在請求失敗時可以重新連接
//retry可以傳入數值表示重試的次數，不填的話預設只會重試1次
var count = 1
    
let sequenceThatErrors = Observable<String>.create { observer in
    observer.onNext("a")
    observer.onNext("b")
    
    //讓第一個訂閱時發生錯誤
    if count == 1 {
        observer.onError(MyError.A)
        debugPrint("Error encountered")
        count += 1
    }
    
    
//    if count == 2 {
//        observer.onError(MyError.A)
//        debugPrint("Error encountered2")
//        count += 1
//    }
//
//    if count == 3 {
//        observer.onError(MyError.A)
//        debugPrint("Error encountered3")
//        count += 1
//    }

    
    observer.onNext("c")
    observer.onNext("d")
    observer.onCompleted()
    
    return Disposables.create()
}
    
sequenceThatErrors
    .retry(2)   //重試2次（參數為空則只重試1次）
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
