import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import PlaygroundSupport
import UIKit

//Traits
//RxSwift除了可被觀察的序列(Observable)，還有提供特徵序列(Traits)

//Traits可以視為Observable的另一個版本，區別在於
//Observable可以用於任何上下文的一般序列
//而Traits可以更精準的描述序列，同時提供了上下文意涵、語法糖等等
let disposeBag = DisposeBag()


//single
debugPrint("--------single---------")
//single是Observable的另一個版本，但不像Observable可以發出多個元素，single只能發出一個元素或是error事件
//發出一個元素，或一個error事件
//不會共享狀態變化

//使用情境：
//single很常使用在Http請求，然後返回一個response或是錯誤訊息，也可以用來描述只有一個元素的序列

//與Data相關的錯誤類型
enum DataError: Error {
    case cantParseJSON
}
//

func getPlaylist(_ channel: String) -> Single<[String: Any]> {
    return Single<[String: Any]>.create { single in
        let url = "https://douban.fm/j/mine/playlist?"
            + "type=n&channel=\(channel)&from=mainsite"

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            if let error = error {
                single(.error(error))
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data,
                                                             options: .mutableLeaves),
                  let result = json as? [String: Any] else {
                single(.error(DataError.cantParseJSON))
                return
            }
            
            single(.success(result))
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}


//getPlaylist("0")
//    .subscribe { event in
//        switch event {
//        case .success(let json):
//            debugPrint("JSON结果: ", json)
//        case .error(let error):
//            debugPrint("發生錯誤: ", error)
//        }
//    }
//    .disposed(by: disposeBag)

//也可以用subscribe(onSuccess:onError:)
//getPlaylist("0")
//    .subscribe(onSuccess: { json in
//        debugPrint("JSON结果: ", json)
//    }, onError: { error in
//        debugPrint("發生錯誤: ", error)
//    })
//    .disposed(by: disposeBag)

//可以用asSingle()將Observable轉換成Single
Observable.of("1")
    .asSingle()
    .subscribe({ debugPrint($0) })
    .disposed(by: disposeBag)


//completable
debugPrint("--------completable---------")
//completable與single一樣，但不同的地方在於只會發生一個completed事件或是error事件
//不會發出任何元素
//只會有一個completed事件或是error事件
//不會共享狀態變化

//使用情境：
//Completable和Observable<Void>很類似，都是用於監測task是否完成，而不是在意返回值，例如：在app退出時將一些數據暫存到local的資料夾，以提供下一次開啟讀取，這種時候就需要知道暫存是否有成功

//將數據暫存到本地端
func cacheLocally() -> Completable {
    return Completable.create { completable in
        //將數據暫存到本地(此為測試所以只提供隨機成功或失敗狀態)
        let success = (arc4random() % 2 == 0)
        
        guard success else {
        completable(.error(CacheError.failedCaching))
            return Disposables.create {}
        }
    
        completable(.completed)
        return Disposables.create {}
    }
}

//與暫存相關的錯誤類型
enum CacheError: Error {
    case failedCaching
}


cacheLocally()
    .subscribe { completable in
    switch completable {
        case .completed:
            debugPrint("儲存成功!")
        case .error(let error):
            debugPrint("儲存失敗: \(error.localizedDescription)")
        }
    }
    .disposed(by: disposeBag)

//也可以使用subscribe(onCompleted:onError:)
//cacheLocally()
//    .subscribe(onCompleted: {
//        debugPrint("儲存成功!")
//        }, onError: { error in
//            debugPrint("儲存失敗: \(error.localizedDescription)")
//        })
//    .disposed(by: disposeBag)


//maybe的特性介於single與completable之間，就是說它可以發出一個元素或是一個completed事件或error事件

//只會有一個事件元素或completed事件或是error事件
//不會共享狀態變化
//maybe適合使用在可能需要發出一個元素，又有可能不需要發出的情況


func generateString() -> Maybe<String> {
    return Maybe<String>.create { maybe in
         
        //成功並發出一個元素
        maybe(.success("hangge.com"))
         
//        //成功但不發出任何元素
//        maybe(.completed)
//
//        //失敗
//        maybe(.error(StringError.failedGenerate))
         
        return Disposables.create {}
    }
}
 
enum StringError: Error {
    case failedGenerate
}


generateString()
    .subscribe { maybe in
    switch maybe {
        case .success(let element):
            print("執行完畢，並取得元素：\(element)")
        case .completed:
            print("執行完畢，且沒有任何元素。")
        case .error(let error):
            print("執行失敗: \(error.localizedDescription)")
        
        }
    }
    .disposed(by: disposeBag)


//asMaybe()可以把Observable序列轉換成maybe
Observable.of("2")
    .asMaybe()
    .subscribe({ debugPrint($0) })
    .disposed(by: disposeBag)
    
//Single、Completable、Maybe為RxSwift Traits
//Driver、ControlEvent這兩個算是用於RxCocoa的Traits，因為這兩個特徵序列專門用於RxCocoa
//driver
debugPrint("--------driver---------")

//driver可以說是最複雜的Traits，它的作用是提供一種簡便的方式在UI層編寫RFP的程式碼
//如果滿足以下條件就使用它
//．不算產生error事件
//．一定要在主線程監控(MainScheduler)
//．共享狀態變化(shareReplayLatestWhileConnected)

//為何要使用driver?
//1.driver最常被使用的情況應該是需要更動app流程時，例如：
//．透過CoreData Model更新UI
//．使用UI元件參數去改變另一個UI元件參數

//2.與一般的作業系統啟動程式一樣，如果程序出現錯誤就應該禁止使用者進行操作
//3.在主線程上觀察這些元素很重要，因為UI元件與程式邏輯通常不是在安全的線程中
//4.driver可以觀察序列，共享狀態變化

//(1)初学者使用 Observable 序列加 bindTo 绑定来实现这个功能的话可能会这么写
//let results = query.rx.text
//    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//    .flatMapLatest { query in
//        fetchAutoCompleteItems(query)//向伺服器發出請求
//    }
//將返回結果綁定到要顯示數量的Label上
//results
//    .map { "\($0.count)" }
//    .bind(to: resultCount.rx.text)
//    .disposed(by: disposeBag)
//將返回結果綁定到TableView上
//results
//    .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
//        cell.textLabel?.text = "\(result)"
//    }
//    .disposed(by: disposeBag)

//上面的範例會有一些問題：
//．如果fetchAutoCompleteItems的序列發生了錯誤(HTTP請求失敗)，這個錯誤將會取消所有綁定。此後使用者再輸入新的文字時，就不會再發出起新的HTTP請求。
//．如果fetchAutoCompleteItems從後台返回前台，那麼刷新頁面也會在後台進行，如此就會造成Crash。
//．返回的结果被綁定到兩個UI元件上。那就意味着，每次使用者輸入一個新的關鍵字時，就會分别為兩個UI元件發出HTTP請求，這並不是所希望的结果。

//(2)所以修改為

//let results = query.rx.text
//    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//    .flatMapLatest { query in
//        fetchAutoCompleteItems(query)
//            .observeOn(MainScheduler.instance)  // 返回到主線程
//            .catchErrorJustReturn([])           // 錯誤被處理，就不會全部停止
//    }
//    .share(replay: 1)                           // HTTP requests是被所有UI元件共享
//
//
//results
//    .map { "\($0.count)" }
//    .bind(to: resultCount.rx.text)
//    .disposed(by: disposeBag)
//
//results
//    .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
//        cell.textLabel?.text = "\(result)"
//    }
//    .disposed(by: disposeBag)
//雖然增加了一些額外處理，讓程式能正常運作，但是在一個大專案中就會顯得複雜了一些會容易出紕漏

//＊建議使用的方式
//(3)使用driver可以簡單實現
//程式碼說明
//第一將使用asDriver()將ControlProperty轉換成driver
//第二使用asDriver(onErrorJustReturn: []) 方法將任何Observable序列都轉換成driver
//任何序列轉換成driver需要滿足三個條件：
//．不會產生error事件
//．一定在主線程監聽(MainScheduler)
//．共享狀態變化(shareReplayLatestWhileConnected)

//asDriver(onErrorJustReturn: [])這一段等價於：
//let safeSequence = xs
//  .observeOn(MainScheduler.instance)        // 主線程監聽
//  .catchErrorJustReturn(onErrorJustReturn)  // 不會產生error
//  .share(replay: 1, scope: .whileConnected) // 共享狀態變化
//
//return Driver(raw: safeSequence)            // 封裝

//第三使用driver時framework會自動加上shareReplayLatestWhileConnected，就不需要再加上`replay`的語句
//第四使用driver取代`bind(to:)`


//let results = query.rx.text.asDriver()//將一般序列轉換成driver序列
//    .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//    .flatMapLatest { query in
//        fetchAutoCompleteItems(query)
//            .asDriver(onErrorJustReturn: [])  //提供這個範例發生錯誤時的返回值
//    }
//
////將返回結果綁定到要顯示數量的Label上
//results
//    .map { "\($0.count)" }
//    .drive(resultCount.rx.text)//使用driver而不是使用`bind(to:)`
//    .disposed(by: disposeBag)
//
////將返回結果綁定到TableView上
//
//results
//    .drive(resultsTableView.rx.items(cellIdentifier: "Cell"))//使用driver而不是使用`bind(to:)`
//    { (_, result, cell) in
//        cell.textLabel?.text = "\(result)"
//    }
//    .disposed(by: disposeBag)
//

//就表示如果程式碼存在driver，那麼序列就不會發生error並且一定會在主線程運作，可以安全綁定UI元件

//controlProperty、 controlEvent
debugPrint("--------controlProperty---------")
//controlProperty專門用來描述UI元件的屬性，這種Trait具有`Observable/ObservableType`的屬性

//controlProperty會有以下特徵：
//．不會發生失敗
//．不會發生error事件
//．共享狀態變化
//．一定在主線程(MainScheduler)訂閱
//．一定在主線程(MainScheduler)監聽

//範例
//UISearchBar+Rx
extension Reactive where Base: UISearchBar {
    /// Reactive wrapper for `text` property.
    public var value: ControlProperty<String?> {
        let source: Observable<String?> = Observable.deferred { [weak searchBar = self.base as UISearchBar] () -> Observable<String?> in
            let text = searchBar?.text

            return (searchBar?.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBar(_:textDidChange:))) ?? Observable.empty())
                    .map { a in
                        return a[1] as? String
                    }
                    .startWith(text)
        }

        let bindingObserver = Binder(self.base) { (searchBar, text: String?) in
            searchBar.text = text
        }

        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}

//UISegmentedControl+Rx
extension Reactive where Base: UISegmentedControl {
    /// Reactive wrapper for `selectedSegmentIndex` property.
    public var selectedSegmentIndex: ControlProperty<Int> {
        value
    }

    /// Reactive wrapper for `selectedSegmentIndex` property.
    public var value: ControlProperty<Int> {
        return controlProperty(
            editingEvents: [.valueChanged],
            getter: { segmentedControl in
                segmentedControl.selectedSegmentIndex
            },
            setter: { segmentedControl, value in
                segmentedControl.selectedSegmentIndex = value
        })
        
//        return UIControl.rx.value(
//            self.base,
//            getter: { segmentedControl in
//                segmentedControl.selectedSegmentIndex
//            }, setter: { segmentedControl, value in
//                segmentedControl.selectedSegmentIndex = value
//            }
//        )
    }
}

//UITextField+Rx
extension Reactive where Base: UITextField {

    public var text: ControlProperty<String?> {
        return value
    }

    public var value: ControlProperty<String?> {
        return controlProperty(
            editingEvents: [.allEditingEvents, .valueChanged],
            getter: { textField in
                textField.text
                
            },
            setter:{ textField, value in
                if textField.text != value {
                    textField.text = value
                }
            })
        
//        return base.rx.controlPropertyWithDefaultEvents(
//            getter: { textField in
//                textField.text
//            },
//            setter: { textField, value in
//                if textField.text != value {
//                    textField.text = value
//                }
//            }
//            )
        }

    //......
}

extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

//將TextField輸入的文字綁定到label上
//textField.rx.text
//    .bind(to: label.rx.text)
//    .disposed(by: disposeBag)

debugPrint("--------controlEvent---------")

//controlEvent與controlProperty一樣會有以下特徵：
//．不會發生失敗
//．不會發生error事件
//．共享狀態變化
//．一定在主線程(MainScheduler)訂閱
//．一定在主線程(MainScheduler)監聽


//範例
//UIViewController+Rx
//public extension Reactive where Base: UIViewController {
//
//    /// Reactive wrapper for `viewDidLoad` message `UIViewController:viewDidLoad:`.
//    public var viewDidLoad: ControlEvent<Void> {
//        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
//        return ControlEvent(events: source)
//    }
//}

//UICollectionView+Rx
extension Reactive where Base: UICollectionView {
    
    /// Reactive wrapper for `delegate` message `collectionView:didSelectItemAtIndexPath:`.
    public var itemSelected: ControlEvent<IndexPath> {
        let source = delegate.methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { a in
                return a[1] as! IndexPath
            }
        
        return ControlEvent(events: source)
    }
}


//UIButton+Rx
extension Reactive where Base: UIButton {
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}

//訂閱按鈕點擊事件
//button.rx.tap
//    .subscribe(onNext: {
//        print("Hello World")
//    }).disposed(by: disposeBag)

//給UIVeiwController增加Extension
//把viewDidLoad、viewDidAppear、viewDidLayoutSubviews等ViewController生命週期轉換成ControlEvent，以便給RxSwift項目使用
//增加isVisible序列屬性針對UIVeiwController顯示狀態進行訂閱
//增加isDismissing序列屬性針對UIVeiwController釋放狀態進行訂閱
public extension Reactive where Base: UIViewController {
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear))
    .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews))
        .map { _ in }
        return ControlEvent(events: source)
    }
    
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove))
        .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove))
        .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    public var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning))
        .map { _ in }
        return ControlEvent(events: source)
    }
    
    //表示視圖是否顯示的可觀察序列，當VC顯示狀態改變會出發
    public var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear
        .map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable,
        viewWillDisappearObservable)
    }
    
    //表示頁面被釋放的可觀察序列，當VC被dismiss時會觸發
    public var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss))
        .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}


//
//頁面顯示完畢狀態
// self.rx.isVisible
//    .subscribe(onNext: { visible in
//        print("目前頁面顯示狀態：\(visible)")
//    }).disposed(by: disposeBag)
//
// //頁面載入完畢
// self.rx.viewDidLoad
//     .subscribe(onNext: {
//         print("viewDidLoad")
//     }).disposed(by: disposeBag)
//
// //頁面將要顯示
// self.rx.viewWillAppear
//     .subscribe(onNext: { animated in
//         print("viewWillAppear")
//     }).disposed(by: disposeBag)
//
// //頁面顯示完畢
// self.rx.viewDidAppear
//     .subscribe(onNext: { animated in
//         print("viewDidAppear")
//     }).disposed(by: disposeBag)




class API {

    enum APIError: Error {
        case unknown
        case invalid
    }

    func request() -> Single<String> {
        return Single.create { (single) -> Disposable in

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                let animals = ["Dog", "Cat", "Lion", "Tiger", "Koala", "Monkey", "Pig", "Chicken", "Penguin", "Wolf"]

                let number = Int.random(in: -10..<animals.count)

                if number > 0 {
                    single(.success(animals[number]))
                } else if number > -5 {
                    single(.error(APIError.invalid))
                } else {
                    single(.error(APIError.unknown))
                }

            }

            return Disposables.create()
        }
    }

}
