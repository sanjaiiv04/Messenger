
import UIKit
import MessageKit
struct Message:MessageType
{
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender:SenderType
{
    var photoURL:String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    private var messages=[Message]()
    let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Sanjaii")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
    }
    override func viewDidLayoutSubviews() {
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("hello")))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate,MessagesDisplayDelegate
{
    var currentSender: MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}


