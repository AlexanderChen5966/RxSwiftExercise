//
//  TestViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/10/20.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


class TestViewController: UIViewController {

    @IBOutlet weak var testSegment: UISegmentedControl!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var testImageView: UIImageView!
    let disposeBag = DisposeBag()
    private let apiCalling = APICalling()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        addTableView()
//        bindTableView()
//        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
//        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
//        stepper.layer.cornerRadius = 10
        testSegment.ensureiOS12Style()
        guard let data = NSDataAsset(name: "testgif")?.data else { return }
        let cfData = data as CFData
        if #available(iOS 13.0, *) {
            CGAnimateImageDataWithBlock(cfData, nil) { (_, cgImage, _) in
                let image = UIImage(cgImage: cgImage).withRenderingMode(.alwaysOriginal)
//                self.testImageView.image = image
//                self.testButton.setImage(image, for: .normal)
                self.testSegment.setImage(image, forSegmentAt: 0)
            }
            
            
//            guard let url = Bundle.main.url(forResource: "banana", withExtension: "gif") else { return }
//
//            let cfUrl = url as CFURL
//            CGAnimateImageAtURLWithBlock(cfUrl, nil) { (_, cgImage, _) in
//                let image = UIImage(cgImage: cgImage).withRenderingMode(.alwaysOriginal)
//                self.testSegment.setImage(image, forSegmentAt: 0)
////                self.testButton.setImage(image, for: .normal)
//            }

        } else {
            // Fallback on earlier versions
        }

        testSegment.layoutSubviews()
//        if let keyWindow = UIWindow.key {
//            let alert = UIAlertController(title: "系統升級中", message: "\n若需調整庫存，請暫時先使用後台管理系統電腦版或聯絡客服，敬請見諒！\n", preferredStyle: .alert)
//
//            keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
//        }
        
        switchButton.thumbTintColor = UIColor.orange

        // 設置未選取時( off )的外觀顏色
        switchButton.tintColor = UIColor.systemGreen

        // 設置選取時( on )的外觀顏色
        switchButton.onTintColor = UIColor.red

//        switchButton.backgroundColor = switchButton.tintColor
//        switchButton.layer.cornerRadius = 16
        
        
//        switchButton.subviews[0].subviews[0].backgroundColor = UIColor.systemGreen

    }
    
    @IBAction func buttonHandler(_ sender: UIButton) {
        let controller = UIAlertController(title: "系統升級中", message: "\n若需調整庫存，請暫時先使用後台管理系統電腦版或聯絡客服，敬請見諒！2", preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        
//        let alert = UIAlertController(title: "系統升級中", message: "\n若需調整庫存，請暫時先使用後台管理系統電腦版或聯絡客服，敬請見諒！\n", preferredStyle: .alert)
//        activeVC()?.present(alert, animated: true)

//        if let keyWindow = UIWindow.key {
//            let alert = UIAlertController(title: "系統升級中", message: "\n若需調整庫存，請暫時先使用後台管理系統電腦版或聯絡客服，敬請見諒1！\n", preferredStyle: .alert)
//
//            keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
//        }

    }
    
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
    
    func bindTableView() {
//        // 1 初始化数据源
//        let items = Observable.just((0...30).map {"\($0)" })
//        // 2 绑定数据源到tableView
//        items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){ (row, element, cell) in
//            cell.textLabel?.text = "\(element)"
//            }
//            .disposed(by: disposeBag)
//        // 3 设置点击事件
//        tableView.rx.modelSelected(String.self).subscribe(onNext: {
//            print("tap index: \($0)")
//        }).disposed(by: disposeBag)
        let request =  APIRequest()
        let result : Observable<[WebAPIModelElement]> = self.apiCalling.send(apiRequest: request)
        _ = result.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { ( row, model, cell) in
           cell.textLabel?.text = model.title
        }
    }

    
}


public struct WebAPIModelElement: Codable {
    public let userId:Int?
    public let id:Int
    public let title:String
    public let body:String?

}

public enum RequestType: String {
    case GET, POST, PUT,DELETE
}

class APIRequest {
    let baseURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    var method = RequestType.GET
    var parameters = [String: String]()
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
      var request = URLRequest(url: baseURL)
       request.httpMethod = method.rawValue
       request.addValue("application/json", forHTTPHeaderField: "Accept")
       return request
   }

}

class APICalling {
    // create a method for calling api which is return a Observable
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
//                    let model: WebAPIModelElement = try JSONDecoder().decode(WebAPIModelElement.self, from: data ?? Data())
//                    observer.onNext( model as! T)
                    
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)

                    
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    
    var topViewController: UIViewController? {
            // 用遞迴的方式找到最後被呈現的 view controller。
            if var topVC = rootViewController {
                while let vc = topVC.presentedViewController {
                    topVC = vc
                }
                return topVC
            } else {
                return nil
            }
        }
}

public struct Utilities
{

    public static var currentViewController: UIViewController?
    {
        guard let parentViewController = UIWindow.key?.rootViewController else {
            return nil
        }
        
        switch parentViewController
        {
        case let navigationController as UINavigationController:
            return navigationController.visibleViewController
            
        case let tabBarViewController as UITabBarController:
            
            guard let viewController = tabBarViewController.selectedViewController else
            {
                return parentViewController
            }
            
            guard let innserNavigationController = viewController as? UINavigationController else
            {
                return viewController
            }
            
            return innserNavigationController.visibleViewController
            
        default:
            return parentViewController
        }
    }
}




extension TestViewController {
    func activeVC() -> UIViewController? {
        // Use connectedScenes to find the .foregroundActive rootViewController
        var rootVC: UIViewController?
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if scene.activationState == .foregroundActive {
                    rootVC = (scene.delegate as? UIWindowSceneDelegate)?.window!!.rootViewController
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
        // Then, find the topmost presentedVC from it.
        var presentedVC = rootVC
        while presentedVC?.presentedViewController != nil {
            presentedVC = presentedVC?.presentedViewController
        }
        return presentedVC
    }

}


extension UISegmentedControl {
    /// Tint color doesn't have any effect on iOS 13.
    func ensureiOS12Style() {
        if #available(iOS 13, *) {

            let backGroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
            let dividerImage = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))

            setBackgroundImage(backGroundImage, for: .normal, barMetrics: .default)
            setBackgroundImage(dividerImage, for: .selected, barMetrics: .default)

            setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
            setTitleTextAttributes([.foregroundColor: tintColor], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

//            setTitleTextAttributes([.foregroundColor: tintColor], for: .selected)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                for i in 0...(self.numberOfSegments-1)  {
//                    let backgroundSegmentView = self.subviews[i]
//                    //it is not enogh changing the background color. It has some kind of shadow layer
//                    backgroundSegmentView.isHidden = true
//                }
//            }
            
        } else {
            self.tintColor = tintColor
        }
    }
}
