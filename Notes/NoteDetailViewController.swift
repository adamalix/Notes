
import UIKit

protocol NoteDetailViewControllerDelegate: class {
    func didSave(note note: Note)
}

class NoteDetailViewController: UIViewController {
    weak var delegate: NoteDetailViewControllerDelegate? = nil
    
    private let originalNote: Note
    private var note: Note
    
    private lazy var nameField: UITextField! = {
        let field = UITextField()
        field.placeholder = "Note name"
        field.addTarget(self, action: #selector(nameFieldChanged), forControlEvents: .EditingChanged)
        field.layer.borderWidth = 1.0
        field.layer.borderColor = InputFieldBorderColor.CGColor
        return field
    }()

    private lazy var contentField: UITextView! = {
        let view = UITextView()
        view.delegate = self
        view.textColor = .blackColor()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = InputFieldBorderColor.CGColor
        view.font = self.nameField.font
        view.textColor = self.nameField.textColor
        view.textContainer.lineFragmentPadding = 0.0
        return view
    }()
    
    private lazy var separatorStroke: CALayer! = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blackColor().CGColor
        return layer
    }()
    
    private lazy var saveButton: UIButton! = {
        let button = UIButton()
        button.setTitle("Save", forState: .Normal)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitleColor(.grayColor(), forState: .Disabled)
        button.backgroundColor = .blackColor()
        button.enabled = false
        button.addTarget(self, action: #selector(saveNote_shim), forControlEvents: .TouchUpInside)
        return button
    }()
    
    init(note: Note = Note(title: "", contents: "")) {
        originalNote = note
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        view.addSubview(nameField)
        view.layer.addSublayer(separatorStroke)
        view.addSubview(contentField)
        view.addSubview(saveButton)
        
        nameField.text = originalNote.title
        contentField.text = originalNote.contents
    }
    
    override func viewDidLayoutSubviews() {
        var nameFrame, contentFrame: CGRect
        (nameFrame, contentFrame) = view.bounds.divide(NameLineHeight + InputFieldInset * 2.0, fromEdge: .MinYEdge)
        separatorStroke.frame = CGRect(x: 10.0, y: nameFrame.maxY, width: nameFrame.maxX - 20.0, height: 1.0)
        (saveButton.frame, contentFrame) = contentFrame.divide(SaveButtonHeight, fromEdge: .MaxYEdge)
        nameField.frame = CGRectInset(nameFrame, InputFieldInset, InputFieldInset)
        contentField.frame = CGRectInset(contentFrame, InputFieldInset, InputFieldInset)
    }
    
    private func hasBeenEdited() -> Bool {
        return originalNote.title != note.title || originalNote.contents != note.contents
    }
    
    @objc private func nameFieldChanged() {
        note.title = nameField.text ?? ""
        saveButton.enabled = hasBeenEdited()
    }
    
    @objc private func saveNote_shim() {
        delegate?.didSave(note: note)
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        note.contents = textView.text
        saveButton.enabled = hasBeenEdited()
    }
}

private let InputFieldInset: CGFloat = 5.0
private let InputFieldBorderColor = UIColor(white: 0.8, alpha: 1.0)
private let NameLineHeight: CGFloat = 44.0
private let SaveButtonHeight: CGFloat = 44.0

