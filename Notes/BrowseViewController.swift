
import UIKit

protocol BrowseViewControllerDelegate: class {
    var notes: [Note] { get }
    
    func addNote()
    func view(note: Note)
    func remove(note: Note)
}

private let NoteSummaryCellReuseId = "Note Summary Cell"

class BrowseViewController: UITableViewController {
    
    weak var delegate: BrowseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addNote_shim))
    }

    @objc private func addNote_shim() {
        delegate?.addNote()
    }
}

extension BrowseViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.notes.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let note = delegate?.notes[indexPath.row] else {
            fatalError()
        }
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(NoteSummaryCellReuseId)
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: NoteSummaryCellReuseId)
        }
        
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.contents
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let note = delegate?.notes[indexPath.row] else {
            fatalError()
        }
        delegate?.view(note)
    }
}