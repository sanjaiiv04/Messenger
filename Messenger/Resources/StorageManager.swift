import FirebaseStorage
import Foundation

final class StorageManager
{
    static let shared = StorageManager()
    private let storage = Storage.storage().reference() //instance to the firebase storage
    
    
    public typealias UploadPicCompletion = (Result<String,Error>)->Void
    ///uploads picture to firebase storage and returns completion with url to download
    public func uploadProfilePic(with data:Data, fileName:String,completion:@escaping UploadPicCompletion)
    {
        //the profile picture is stored in the directory format: /images/test123-gmail-com_profile_picture.jpg
        storage.child("images/\(fileName)").putData(data, completion: {metadata,error in
            guard error==nil else
            {
                print("Failed to upload")
                completion(.failure(StorageError.failedToUpload))
                return
            }
             self.storage.child("images/\(fileName)").downloadURL(completion: {url,error in
                guard let url=url else
                {
                    completion(.failure(StorageError.failedToGetDownloadURL))
                    return
                }
                 let urlString = url.absoluteString
                 print("Download URL returned:\(urlString)")
                 completion(.success(urlString))
            })
        })
    }
    public enum StorageError:Error{
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path:String, completion:@escaping(Result<URL,Error>)->Void)
    {
        let ref = storage.child(path)
        ref.downloadURL(completion: {url,error in
            guard let url=url,error==nil else
            {
                completion(.failure(StorageError.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        })
    }
}
