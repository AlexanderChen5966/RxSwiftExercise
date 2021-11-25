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

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
label.text = "測試資料"
label.textAlignment = .center
label.center = windowView.center


//.bind
let disposeBag = DisposeBag()
//let bindObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
//
//bindObservable.map{
//    "目前的Index:\($0)"
//}
//.bind{
//     (text) in
//    label.text = text
//}
//.disposed(by: disposeBag)

//windowView.addSubview(label)
PlaygroundPage.current.liveView = windowView

//AnyObserver：可以用來描述任意一種觀察者
//使用.bind方法綁定事件
//1 生成一個Label
let binderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
binderLabel.text = "隱藏Label"
binderLabel.textAlignment = .center
binderLabel.center = windowView.center

//2 建立一個觀察者，並指定binderLabel是否隱藏
let anyObserver: AnyObserver<Bool> = AnyObserver {
    event in
    switch event {
    case .next(let data):
        binderLabel.isHidden = data
        debugPrint(data)
    case .error(let error):
        debugPrint(error)
    case .completed:
        debugPrint("completed")

    }
}

//3 建立Obervable放入true，並使用.bind綁定anyObserver
let binderStatusObservable:Observable<Bool> = Observable.just(false)//true false交互使用
binderStatusObservable.bind(to: anyObserver)


//使用Binder綁定事件
/*
 有兩個特性
 - 不會處理錯誤事件
 - 確保Binder都是在給定的Scheduler上執行(預設為 MainScheduler)
 */

let binderObserver: Binder<Bool> = Binder(binderLabel) {
    (view,value) in
    view.isHidden = value
}

binderStatusObservable.bind(to: binderObserver).disposed(by: disposeBag)

windowView.addSubview(binderLabel)
PlaygroundPage.current.liveView = windowView
