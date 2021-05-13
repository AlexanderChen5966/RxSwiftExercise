import Foundation
import RxSwift
import PlaygroundSupport
import RxCocoa
import UIKit

// Observer觀察者，是用來監聽事件，跳出提示框就是觀察者對'點擊按鈕'的事件做出響應

//建立觀察者最常見的方式就是在Observable的"subscribe"方法後面的描述，事件發生時該如何響應，觀察者就是由下面範例的onNext、onError、onCompleted閉包所組成
let observable = Observable.of("A", "B", "C")
observable.subscribe(
    onNext: { element in
    debugPrint(element)
}, onError: { error in
    debugPrint(error)
}, onCompleted: {
    debugPrint("completed")
})

let windowView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
windowView.backgroundColor = .white


//bind
let disposeBag = DisposeBag()
let bindObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
label.text = "測試資料"
label.textAlignment = .center
label.center = windowView.center



bindObservable.map{
    "目前的Index:\($0)"
}
.bind{
     (text) in
    label.text = text
}
.disposed(by: disposeBag)

//PlaygroundPage.current.liveView = label

windowView.addSubview(label)
PlaygroundPage.current.liveView = windowView

//AnyObserver：可以用來描述任意一種觀察者
//
let anyObserver: AnyObserver<String> = AnyObserver {
    event in
    switch event {
    case .next(let data):
        debugPrint(data)
    case .error(let error):
        debugPrint(error)
    case .completed:
        debugPrint("completed")

    }
}

let anyObservable = Observable.of("A", "B", "C")
anyObservable.subscribe(anyObserver)


//Binder
/*
 有兩個特性
 - 不會處理錯誤事件
 - 確保Binder都是在給定的Scheduler上執行(預設為 MainScheduler)
 */

//1 生成一個Label
let binderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))

//2 建立一個觀察者
let observer1: AnyObserver<Bool> = AnyObserver { (event) in
    switch event {
    case .next(let isHidden):
        binderLabel.isHidden = isHidden
    default:
        break
    }
}
//let usernameValid:Observable<Bool> = Observable.create { event in
//    observer.onNext(true)
//    return Disposables.create()
//}

let binderStatusObserver:Observable<Bool> = Observable.just(true)

binderStatusObserver.bind(to: observer1)
//

//let observer = binderLabel.rx.text
//let text: Observable<String?> = Observable.just("")
//text.bind(to: observer)
let observer2: Binder<Bool> = Binder(binderLabel) {
    (view,text) in
    
}

let binderObserver:Binder<String> = Binder(binderLabel) {
    (view, text) in
    view.text = text
}

//let binderObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
//binderObservable.map{
//    "目前的Index1:\($0)"
//}
//.bind(to: binderObserver)
//.disposed(by: disposeBag)
//
//
//PlaygroundPage.current.liveView = binderLabel

