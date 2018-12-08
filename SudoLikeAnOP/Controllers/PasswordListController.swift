import Cocoa

class PasswordListController: NSViewController {
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    let fetchedPasswords: [PasswordListItem] = PasswordLibraryFactory.shared.retrievePasswordList()
    var passwords: [PasswordListItem] = []
    
    func filterPasswords() {
        let searchString = searchField.stringValue.lowercased()
        if (searchString.count > 0){
            passwords = fetchedPasswords.filter { (passwordItem) -> Bool in
                passwordItem.name.lowercased().contains(searchString)
            }
        } else {
            passwords = fetchedPasswords
        }
        tableView.reloadData()
        selectFirstRow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwords = fetchedPasswords
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
        case 36: // Return
            if (tableView.numberOfRows > 0){
                let uuid = passwords[tableView.selectedRow].uuid
                print(PasswordLibraryFactory.shared.retrievePassword(uuid: uuid) ?? "")
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
