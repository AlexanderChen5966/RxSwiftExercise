import UIKit
import RxSwift

//:這是個人的一點學習心得記錄，不代表觀念一定是正確的，如果看到錯誤的地方歡迎指正

/*:
 ## RxSwift是什麼
 * RxSwift是一種響應式程式設計 FRP(Functional Reactive Programming)框架
 * 也就是一種聲明式(Declarative)的程式設計方式，所以會比命令式程式設計 (Imperative Programming)更難理解，需要很多時間進行消化與了解
 */

/*:
 ### RxSwift由三部分组成
 - Observables(被觀察者):資料的提供者
 - Operators:在送出與接收資料之間進行處理的用途
 - Schedulers:線程和序列的調度器，作用是控制序列與線程運作
 ---
 
 RxSwift就是 = Observables + Operators + Schedulers
 */

//觀察者模式 Observer pattern
//被觀察者(Observable)：是一個可監聽的序列
//觀察者(Observer)：序列的監聽者

//疊代器模式 Iterator pattern
//訂閱(Subscribe)

/*:
 https://zhang759740844.github.io/2017/10/26/RxSwift%E4%B8%80%E4%BA%9B%E6%A6%82%E5%BF%B5/#Subject-%E4%B8%8E-Observable-%E7%9A%84%E4%B8%8D%E5%90%8C
 
 */

// just()
let justObservable = Observable<Int>.just(5)


// of()
let ofObservable = Observable.of("A","B","C")


let disposeBag = DisposeBag()
//let publicSubject = PublishSubject<String>()

let subject = PublishSubject<Int>() //PublishSubject最一開始會是空的，你要先訂閱，才能收到往後發出的新元素
//Subject可以發送元素給他的訂閱者，這時Subject作為一個Observable的角色
//subject
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

//或是寫成

subject
    .asObserver()
    .subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

// Subject 可以接收.next, .completed, .error事件
// subject.onNext(1)表示，『Subject接收到數字1』 ，這時的Subject是作為一個Observer的角色
//subject.onNext(1)
//subject.onNext(2)
//subject.onNext(3)

subject.asObserver().onNext(1)
