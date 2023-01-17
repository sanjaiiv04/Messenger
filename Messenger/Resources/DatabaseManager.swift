
import Foundation
import Firebase

final class DatabaseManager
{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    static func safeEmail(emailAddress:String)->String
    {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    /*public func test()
    {
        database.child("foo").setValue(["something":true])
    }*/
}
extension DatabaseManager
{
    public func getAllUsers(completion:@escaping(Result<[[String:String]], Error>)->Void)
    {
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value=snapshot.value as? [[String:String]] else
            {
                completion(.failure("Failed to fetch" as! Error))
                return
            }
            completion(.success(value))
        })
    }
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
    
    public func insertUser(with user: ChatAppUser,completion: @escaping(Bool)->Void)
    {
        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName],withCompletionBlock: { error,_ in
            guard error==nil else
            {
                print("failed to upload to database")
                completion(false)
                return
            }
            /// creating a one big array called users where we store all the names ans safe emails of all the users which can then be used to search for a conversation
            self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String:String]]
                {
                    let newCollection:[[String:String]]=[["name":user.firstName+" "+user.lastName,"email":user.safeEmail]]
                    self.database.child("users").setValue(usersCollection,withCompletionBlock: {error,_ in
                        guard error==nil else
                        {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                    usersCollection.append(contentsOf: newCollection)
                }
                else
                {
                    let newCollection:[[String:String]]=[["name":user.firstName+" "+user.lastName,"email":user.safeEmail]]
                    self.database.child("users").setValue(newCollection,withCompletionBlock: {error,_ in
                        guard error==nil else
                        {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
        })
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
    var profilePicFileName: String{
        return "\(safeEmail)_profile_picture.png"
    }
}
