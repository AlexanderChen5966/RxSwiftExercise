import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

//自定義可綁定屬性
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}


let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
label.text = "Google"
let disposeBag = DisposeBag()

let customObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    
customObservable.map{
    CGFloat($0)
}
.bind(to: label.fontSize)
.disposed(by: disposeBag)





//通過對Reactive 類進行擴展
extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

customObservable.map{CGFloat($0)}
    .bind(to: label.rx.fontSize)
    .disposed(by: disposeBag)


//針對UIView類擴充隱藏的參數
extension Reactive where Base: UIView {
  public var isHidden: Binder<Bool> {
      return Binder(self.base) { view, hidden in
          view.isHidden = hidden
      }
  }
}

let windowView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
windowView.backgroundColor = .white

let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
contentView.backgroundColor = .red
contentView.center = windowView.center


let hiddenObservable = Observable<Bool>.just(false)
hiddenObservable.bind(to: contentView.rx.isHidden).disposed(by: disposeBag)
//windowView.addSubview(contentView)
//PlaygroundPage.current.liveView = windowView



//RxSwift 自帶的可綁定屬性（UI 觀察者）
extension Reactive where Base: UILabel {

    /// Bindable sink for `text` property.
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }

    /// Bindable sink for `attributedText` property.
    public var attributedText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }

}
customObservable.map{"目前的Index:\($0)"}
    .bind(to: label.rx.text)
    .disposed(by: disposeBag)


PlaygroundPage.current.liveView = label


