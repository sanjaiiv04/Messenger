
import Foundation
import Firebase

final class DatabaseManager
{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    /*public func test()
    {
        database.child("foo").setValue(["something":true])
    }*/
}
extension DatabaseManager
{
    //returns true with user exists hence there is no redundancy in database
    public func userExists(with email:String,completion: @escaping ((Bool)->Void))
    {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else
            {
                completion(false)
                return
            }
            completion(true)
        })
    }
    /// Inserts new user to database
    
    public func insertUser(with user: ChatAppUser)
    {
        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName])
    }
}
struct ChatAppUser
{
    let firstName: String
    let lastName: String
    let emailAddress:String
    
    //computed property
    var safeEmail:String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //let profilePicUrl: String
}
