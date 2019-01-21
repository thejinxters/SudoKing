import Cocoa

class PasswordListController: NSViewController {
    @IBOutlet weak var searchView: NSView!
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    let fetchedPasswordsOpt: [PasswordListItem]? = try? PasswordLibraryFactory.shared.retrievePasswordList()
    var passwords: [PasswordListItem] = []
    
    func filterPasswords() {
        if fetchedPasswordsOpt != nil {
            let searchString = searchField.stringValue.lowercased()
            if (searchString.count > 0){
                passwords = fetchedPasswordsOpt!.filter { $0.name.lowercased().contains(searchString) }
            } else {
                passwords = fetchedPasswordsOpt!
            }
            tableView.reloadData()
            selectFirstRow()
        }
    }
    
    override func viewDidLoad() {
        // Modify look and feel of textfield
        searchView.wantsLayer = true
        searchView.layer?.backgroundColor = Colors.LightTeal.cgColor
        searchField.focusRingType = NSFocusRingType.none
        searchField.isBezeled = false
        searchField.drawsBackground = false
        
        tableView.focusRingType = NSFocusRingType.none
        tableView.backgroundColor = Colors.DarkTeal
        
        searchField.becomeFirstResponder()
        tableView.refusesFirstResponder = true
        
        passwords = fetchedPasswordsOpt ?? [] // TODO: should report an error if nothing can load
        searchField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        selectFirstRow()
        
        // Registers keyDown listener within view
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    
    override func keyDown(with event: NSEvent){
        switch event.keyCode {
        case KeyCodes.downArrow, KeyCodes.keypad8:
            selectNextRow()
            break
        case KeyCodes.upArrow, KeyCodes.keypad2:
            selectPreviousRow()
            break
        case KeyCodes.returnKey:
            if (tableView.numberOfRows > 0){
                let uuid = passwords[tableView.selectedRow].uuid
                let password: String? = try? PasswordLibraryFactory.shared.retrievePassword(uuid: uuid)
                print(password ?? "")
                self.view.window?.close()
            }
            break
        default:
            break
        }
    }
    
    func selectFirstRow() {
        if (tableView.numberOfRows > 0){
            tableView.selectRowIndexes(.init(integer: 0), byExtendingSelection: false)
        }
    }
    
    func selectNextRow() {
        if (tableView.numberOfRows > 0){
            let indexToSelect = (tableView.selectedRow + 1) % tableView.numberOfRows
            tableView.selectRowIndexes(.init(integer: indexToSelect), byExtendingSelection: false)
        }
    }
    
    func selectPreviousRow() {
        if (tableView.numberOfRows > 0){
            let indexToSelect = (tableView.selectedRow + tableView.numberOfRows - 1) % tableView.numberOfRows
            tableView.selectRowIndexes(.init(integer: indexToSelect), byExtendingSelection: false)
        }
    }
}

extension PasswordListController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return passwords.count
    }
}

extension PasswordListController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let NameCell = "PasswordCellID"
    }
    
    class MyNSTableRowView: NSTableRowView {
        
        override func drawSelection(in dirtyRect: NSRect) {
            if self.selectionHighlightStyle != .none {
                let selectionRect = NSInsetRect(self.bounds, 0, 0)
                Colors.DarkTeal.setStroke()
                Colors.VeryDarkTeal.setFill()
                let selectionPath = NSBezierPath.init(roundedRect: selectionRect, xRadius: 0, yRadius: 0)
                selectionPath.fill()
                selectionPath.stroke()
            }
        }
    }
    
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return MyNSTableRowView()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        var text: String = ""
        var cellIdentifier: String = ""

        let item = passwords[row].name

        if tableColumn == tableView.tableColumns[0] {
            text = item
            cellIdentifier = CellIdentifiers.NameCell
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
}

extension PasswordListController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        self.filterPasswords()
    }
}
