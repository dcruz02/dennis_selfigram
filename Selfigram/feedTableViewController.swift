//
//  feedTableViewController.swift
//  Selfigram
//
//  Created by Dennis Cruz on 2018-07-16.
//  Copyright © 2018 Dennis Cruz. All rights reserved.
//

import UIKit

class feedTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var words = ["Hello", "my", "name", "is", "Selfigram"]
//
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=38d69d9511b8ba86dc4ace1c9fe8e944&tags=fixedgear")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            // convert Data to JSON
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                
                let json = jsonUnformatted as? [String : AnyObject]
                let photosDictionary = json?["photos"] as? [String : AnyObject]
                
                if let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] {
                    
                    for photo in photosArray {
                        
                        if let farmID = photo["farm"] as? Int,
                            let serverID = photo["server"] as? String,
                            let photoID = photo["id"] as? String,
                            let secret = photo["secret"] as? String {
                            
                            let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                            print(photoURLString)
                            
                            if let photoURL = URL(string: photoURLString) {
                                
                                let me = User(usernameInp: "sam", profileImageInp: UIImage(named: "Grumpy-Cat")!)
                                let post = Post(imageInp: photoURL, userInp: me, commentInp: "A Flickr Selfie")
                                self.posts.append(post)
                            }
                            
                        }
                        
                    }
                    // We use OperationQueue.main because we need update all UI elements on the main thread.
                    // This is a rule and you will see this again whenever you are updating UI.
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                }
                
            }else{
                print("error with response data")
            }
            
            //print ("inside dataTaskWithURL with data = \(data!)")
            
        })

        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
//        let me = User(usernameInp: "dennis", profileImageInp: UIImage(named: "Grumpy-Cat")!)
//        let post0 = Post(imageInp: UIImage(named: "Grumpy-Cat")!, userInp: me, commentInp: "Grumpy Cat 0")
//        let post1 = Post(imageInp: UIImage(named: "Grumpy-Cat")!, userInp: me, commentInp: "Grumpy Cat 1")
//        let post2 = Post(imageInp: UIImage(named: "Grumpy-Cat")!, userInp: me, commentInp: "Grumpy Cat 2")
//        let post3 = Post(imageInp: UIImage(named: "Grumpy-Cat")!, userInp: me, commentInp: "Grumpy Cat 3")
//        let post4 = Post(imageInp: UIImage(named: "Grumpy-Cat")!, userInp: me, commentInp: "Grumpy Cat 4")
//
//        posts = [post0, post1, post2, post3, post4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selfieCell", for: indexPath) as! selfieCellTableViewCell

        // Configure the cell...
        //cell.textLabel?.text = "This is Post \(indexPath.row)"
        //cell.textLabel?.text = words[indexPath.row]
//        let post = posts[indexPath.row]
//        cell.imageView?.image = post.image
//        cell.textLabel?.text = post.comment
//        let post = self.posts[indexPath.row]
//        cell.selfieImageView.image = post.image
//        cell.usernameLabel.text = post.user.username
//        cell.commentLabel.text = post.comment
        
        let post = self.posts[indexPath.row]
        cell.selfieImageView.image = nil
        
        
        let task = URLSession.shared.downloadTask(with: post.imageURL) { (url, response, error) -> Void in
            
            if let imageURL = url, let imageData = try? Data(contentsOf: imageURL) {
                OperationQueue.main.addOperation {
                    
                    cell.selfieImageView.image = UIImage(data: imageData)
                    
                }
            
            
            }
        }
        
        task.resume()
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        return cell
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        print("Camera button pressed")
        
        
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .photoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        //if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //2. We create a Post object from the image
//            let me = User(usernameInp: "sam", profileImageInp: UIImage(named: "Grumpy-Cat")!)
//            let post = Post(imageInp: image, userInp: me, commentInp: "My Selfie")
            
            //posts.insert(post, at: 0)
            
        //}
    
        //3. Add post to our posts array
        //    Adds it to the very top of our array
        //posts.insert(posts, at: 0)
    
    
        //3. We remember to dismiss the Image Picker from our screen.
        dismiss(animated: true, completion: nil)
    
        //5. Now that we have added a post, reload our table
        tableView.reloadData()

            
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
