import Cocoa

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        Log.info(message: "Main Window Loaded")
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 53: // Escape
            self.window?.close()
            break
        default:
            break
        }
    }
    
    func loadPasswordListView(validPassword: Bool){
        if validPassword {
            let sceneIdentifier = NSStoryboard.SceneIdentifier("passwordList")
            let viewController = self.storyboard?.instantiateController(withIdentifier: sceneIdentifier)
                as! NSViewController
            self.window?.contentViewController = viewController
        }
    }

}
