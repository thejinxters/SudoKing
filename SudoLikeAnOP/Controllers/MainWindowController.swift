import Cocoa

class MainWindowController: NSWindowController {
    
    func loadPasswordListView(validPassword: Bool){
        if validPassword {
            let sceneIdentifier = NSStoryboard.SceneIdentifier("passwordList")
            let viewController = self.storyboard?.instantiateController(withIdentifier: sceneIdentifier)
                as! NSViewController
            self.window?.contentViewController = viewController
        }
    }

}
