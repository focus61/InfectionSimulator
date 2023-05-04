import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let ws = (scene as? UIWindowScene) else { return }
        window?.frame = ws.coordinateSpace.bounds
        window?.windowScene = ws
        window?.rootViewController = UINavigationController(
            rootViewController: SimulationInputViewController()
        )
        window?.makeKeyAndVisible()
    }
}
