import UIKit

/*
let greenScene = GreenVC.instantiate(fromAppStoryboard: .Main)
let greenScene = AppStoryboard.Main.viewController(viewControllerClass: GreenVC.self)
let greenScene = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: GreenVC.storyboardID)
*/

// MARK: Storyboard
protocol StoryboardIdentifiable {
	static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
	
	static var storyboardIdentifier: String {
		return String(describing: self)
	}
	
	static func instantiate(fromStoryboard appStoryboard: AppStoryboard) -> Self {
		return appStoryboard.viewController(viewControllerClass: self)
	}
}


// MARK: Storyboards
enum AppStoryboard: String {
	
	//Tabs
	case main = "Main"
	case dashboard = "Dashboard"
    case schedule = "Schedule"
    case groups = "Groups"
    case trips = "Trips"

	var storyboard: UIStoryboard {
		return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
	}
	
	func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
		let storyboardId = (viewControllerClass as UIViewController.Type).storyboardIdentifier
		guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as? T else {
			fatalError("ViewController with identifier \(storyboardId), not found")
		}
		return vc
	}
}


// MARK: UIStoryboard
extension UIStoryboard {
	
	convenience init(storyboard: AppStoryboard, bundle: Bundle? = nil) {
		self.init(name: storyboard.rawValue, bundle: bundle)
	}
	
	//instantiate with ViewController name
	func instantiateViewController<T: UIViewController>() -> T {
		guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
			fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
		}
		return viewController
	}
}

