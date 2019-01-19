import Cocoa

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        Log.info("Sudo Like an OP loaded")
        removeApplicaitonTitleBar()
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
    
    func removeApplicaitonTitleBar() {
        self.window?.titleVisibility = NSWindow.TitleVisibility.hidden
        self.window?.titlebarAppearsTransparent = true
    }
    
    func attemptLoadPasswordListView(){
        
        if PasswordLibraryFactory.shared.validSessionActive() {
            let sceneIdentifier = NSStoryboard.SceneIdentifier("passwordList")
            let viewController = self.storyboard?.instantiateController(withIdentifier: sceneIdentifier)
                as! NSViewController
            self.window?.contentViewController = viewController
        }
    }
    
}
