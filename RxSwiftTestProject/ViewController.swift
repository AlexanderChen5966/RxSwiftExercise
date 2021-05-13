//
//  ViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/9.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
//        rxSwiftForObservable()
//        rxSwiftForObservableLifeCycle()
//        rxSwiftDisposeEvent()
        
//        rxSwiftObserver()
//        rxSwiftAnyObserver()
//        rxSwiftBindObserver()
        
        
//        rxSwiftDebounce()
        rxSwiftOtherFunc()
    }
    
    
    //Observable訂閱
    func rxSwiftForObservable(){
        //1
        let observable = Observable.of("A", "B", "C")
//        observable.subscribe{
//            (event) in
//            print(event)
//
//            print(event.element ?? "")
//        }
        
//        observable.subscribe({ event in
//            print(event.element ?? "")
//        })
        
        
        //2
//        observable.subscribe(onNext: { (element) in
//            print(element)
//        }, onError: { (error) in
//            print(error)
//        }, onCompleted: {
//            print("completed")
//        }) {
//            print("disposed")
//        }
        
        observable.subscribe(onNext: { (element) in
            print(element)
        })
    }
    
    //監聽事件生命週期
    func rxSwiftForObservableLifeCycle(){
        let observable = Observable.of("A", "B", "C")
//        observable
//            .do(onNext: { element in
//                print("Intercepted Next：", element)
//            }, onError: { error in
//                print("Intercepted Error：", error)
//            }, onCompleted: {
//                print("Intercepted Completed")
//            }, onDispose: {
//            print("Intercepted Disposed")
//            })
//            .subscribe(onNext: { element in
//                print(element)
//            }, onError: { error in
//                print(error)
//            }, onCompleted: {
//                print("completed")
//            }, onDisposed: {
//                print("disposed")
//            })
        
        
        observable.do(onNext: { (element) in
            print("Intercepted Next：", element)

        }, afterNext: { (afterElement) in
            print("Intercepted afterElement：", afterElement)

        }, onError: { (error) in
            print("Intercepted error：", error)

        }, afterError: { (afterError) in
            print("Intercepted afterError：", afterError)

        }, onCompleted: {
            print("Intercepted onCompleted：")

        }, afterCompleted: {
            print("Intercepted afterCompleted：")

        }, onSubscribe: {
            print("Intercepted onSubscribe：")

        }, onSubscribed: {
            print("Intercepted onSubscribed：")

        }) {
            print("Intercepted disposed：")

        }
        .subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
    }
    
    //Observable的銷毀
    func rxSwiftDisposeEvent(){
        let observable = Observable.of("A", "B", "C")
        
        //使用subscription常數儲存這個訂閱方法
//        let subscription = observable.subscribe { event in
//            print(event)
//        }
        
        //1 使用dispose()方法，銷毀訂閱
//        subscription.dispose()
        
        
        //2 DisposeBag
        let disposeBag = DisposeBag()

        //第1個Observable，及其訂閱
        let observable1 = Observable.of("A", "B", "C")
        observable1.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)

        //第2個Observable，及其訂閱
        let observable2 = Observable.of(1, 2, 3)
        observable2.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
    }
    
    func setupButton() {

//        button.addTarget(self, action: #selector(didClickButton), for: .touchUpInside)
        
//        button.rx.tap
//            .subscribe(onNext: { [weak self] in
//                print("button event for rx")
////                    self?.view.backgroundColor = UIColor.orange
//            })
//            .disposed(by: disposeBag)

        button.rx.tap.bind { _ in
            print("button event for rx")

        }
        .disposed(by: disposeBag)
        
        
    }
    
    @objc func didClickButton(){
        print("button event for target")
    }
}


//MARK:觀察者Observer
extension ViewController {
    
    func rxSwiftObserver(){
        //在bind方法中建立
        //Observable序列（每隔1秒發出）
        let copySelf = self
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map{"目前計數：\($0)秒"}
        .bind { (text) in
            copySelf.label.text = text
        }
        .disposed(by: disposeBag)
    }
    
    //觀察者AnyObserver
    func rxSwiftAnyObserver(){
        
//        let observer:AnyObserver<String> = AnyObserver {
//            event in
//
//            switch event {
//            case .next(let data):
//                print(data)
//            case .error(let error):
//                print(error)
//            case .completed:
//                print("completed")
//            }
//        }
//
//        let observable = Observable.of("D", "E", "F")
//        observable.subscribe(observer)
        
        let copySelf = self
        let observer:AnyObserver<String> = AnyObserver {
            event in
            switch event {
            case .next(let text):
                copySelf.label.text = text
                break
            default:
                break
            }
        }
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
        .map { (count) in  "目前計數：\(count)秒"}
        .bind(to: observer)
        .disposed(by: disposeBag)
        
    }
    
    //使用Bind建立觀察者
    func rxSwiftBindObserver(){
                
        //觀察者
        let observer :Binder<String>  = Binder(self.label) {
            (view,text) in
            view.text = text
        }
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map {"目前計數：\($0)秒" }
        .bind(to: observer)
        .disposed(by: disposeBag)
    }
    
    
}


extension ViewController {

    func rxSwiftDebounce(){
        
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 2.1 ]
        ]
        
        Observable.from(times)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(RxTimeInterval.seconds(Int(item["time"]!)), scheduler: MainScheduler.instance)
//                    .delaySubscription(Double(item["time"]!),scheduler: MainScheduler.instance)
        }
        .debounce(RxTimeInterval.seconds(Int(0.5)), scheduler: MainScheduler.instance)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    }
    
}

extension ViewController {
    func rxSwiftOtherFunc() {
        //Delay
//        Observable.of(1,2,1)
//        .delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
//        .subscribe(onNext: { print($0) })
//        .disposed(by: disposeBag)
        
        //DelaySubscription
//        Observable.of(5,7,9)
//        .delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
//        .subscribe(onNext: { print($0) })
//        .disposed(by: disposeBag)

        //Materialize
//        Observable.of(3,9,4)
//        .materialize()
//        .subscribe(onNext: { print($0) })
//        .disposed(by: disposeBag)

        //Dematerialize
//        Observable.of(7,9,3)
//        .materialize()
//        .dematerialize()
//        .subscribe(onNext: { print($0) })
//        .disposed(by: disposeBag)

        //TimeOut
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 0.5 ],
            [ "value": 3, "time": 5 ],
            [ "value": 4, "time": 4 ],
            [ "value": 5, "time": 1.5 ]
        ]

        Observable.from(times)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(RxTimeInterval.seconds(Int(item["time"]!)), scheduler: MainScheduler.instance)
        }
        .timeout(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        
        .subscribe(onNext: { print($0)
            
        },onError: {error in
                print(error)
        })
        .disposed(by: disposeBag)

        
        //using
        //一個無限序列（每隔0.1秒建立一個序列數 ）
        let infiniteInterval$ = Observable<Int>
            .interval(0.1, scheduler: MainScheduler.instance)
            .do(
                onNext: { print("infinite$: \($0)") },
                onSubscribe: { print("開始訂閱 infinite$")},
                onDispose: { print("銷毀 infinite$")}
            )
        
        //一個有限序列（每隔0.5秒建立一个序列數，共建立三個 ）
        let limited$ = Observable<Int>
            .interval(0.5, scheduler: MainScheduler.instance)
            .take(2)
            .do(
                onNext: { print("limited$: \($0)") },
                onSubscribe: { print("開始訂閱 limited$")},
                onDispose: { print("銷毀 limited$")}
        )
        
        //使用using操作符创建序列
        let o: Observable<Int> = Observable.using({ () -> AnyDisposable in
            return AnyDisposable(infiniteInterval$.subscribe())
        }, observableFactory: { _ in return limited$ }
        )
        o.subscribe()

    }
}

class AnyDisposable: Disposable {
    let _dispose: () -> Void
     
    init(_ disposable: Disposable) {
        _dispose = disposable.dispose
    }
     
    func dispose() {
        _dispose()
    }
}
