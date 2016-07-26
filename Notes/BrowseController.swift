
import UIKit

class BrowseController {
    
    private(set) var notes: [Note] = []
    
    private var navigationController: UINavigationController?
    
    private lazy var browseViewController: BrowseViewController! = {
        let browser = BrowseViewController(nibName: nil, bundle: nil)
        browser.delegate = self
        return browser
    }()
    
    private var detailViewController: NoteDetailViewController?
    
    init() {
        loadStoredNotes()
    }
    
    deinit {
        storeNotes()
    }

    func show(window: UIWindow) {
        browseViewController = BrowseViewController()
        browseViewController?.delegate = self
        
        navigationController = UINavigationController(rootViewController: browseViewController!)
        navigationController?.navigationBar.translucent = false
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func handle(url url: NSURL) -> Bool {
        if let route = NoteRoute(url: url), let note = note(forId: route.id) {
            if navigationController?.topViewController == detailViewController {
                let detail = newDetailViewController(with: note)
                navigationController?.setViewControllers([browseViewController, detail], animated: true)
                detailViewController = detail
            } else {
                view(note)
            }
            return true
        }
        return false
    }
    
    private func notesStorageUrl() -> NSURL {
        let url = NSURL(fileURLWithPath: NSHomeDirectory())
        return url.URLByAppendingPathComponent("Documents/notes.xml")
    }
    
    private func loadStoredNotes() {
        if let storedNotes = NSArray(contentsOfURL: notesStorageUrl()) {
            self.notes = storedNotes.flatMap({ encoded in
                guard let encoded = encoded as? Dictionary<String, String> else { return nil }
                return Note(dictionary: encoded)
            })
        }
    }
    
    private func storeNotes() {
        guard NSArray(array: notes.flatMap({ $0.encode() })).writeToURL(notesStorageUrl(), atomically: true) == true else {
            fatalError()
        }
    }
    
    private func note(forId id: String) -> Note? {
        guard let index = notes.indexOf({ $0.id == id }) else {
            return nil
        }
        return notes[index]
    }
    
    private func newDetailViewController(with note: Note = Note(title: "", contents: "")) -> NoteDetailViewController {
        let detail = NoteDetailViewController(note: note)
        detail.delegate = self
        return detail
    }
    
}

extension BrowseController: BrowseViewControllerDelegate {
    func addNote() {
        let detail = newDetailViewController()
        navigationController?.pushViewController(detail, animated: true)
        detailViewController = detail
    }
    
    func view(note: Note) {
        let detail = newDetailViewController(with: note)
        navigationController?.pushViewController(detail, animated: true)
        detailViewController = detail
    }
    
    func remove(note: Note) {
        guard let index = notes.indexOf({ $0.id == note.id }) else {
            fatalError()
        }
        notes.removeAtIndex(index)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), storeNotes)
        
        browseViewController?.tableView.reloadData()
    }
}

extension BrowseController: NoteDetailViewControllerDelegate {
    func didSave(note note: Note) {
        if let index = notes.indexOf({ $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), storeNotes)
        
        browseViewController?.tableView.reloadData()
        navigationController?.popViewControllerAnimated(true)
    }
}

struct NoteRoute {
    let id: String
    
    init?(url: NSURL) {
        guard url.pathComponents?.first == "notes" else {
            return nil
        }
        guard let id = url.pathComponents?[safe: 1] else {
            return nil
        }
        self.id = id
    }
}

