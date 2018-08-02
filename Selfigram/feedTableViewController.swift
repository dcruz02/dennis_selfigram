//
//  feedTableViewController.swift
//  Selfigram
//
//  Created by Dennis Cruz on 2018-07-16.
//  Copyright © 2018 Dennis Cruz. All rights reserved.
//

import UIKit
import Parse

class feedTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var words = ["Hello", "my", "name", "is", "Selfigram"]
//
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = Post.query(){
            
            query.order(byDescending: "createdAt")
            query.includeKey("user")
            
            query.findObjectsInBackground(block: { (posts, error) -> Void in
                if let posts = posts as? [Post]{
                    self.posts = posts
                    self.tableView.reloadData()
                }
            })
        }
        
    }

        // this is called to start (or restart, if needed) our task
        //task.resume()
        
        //print ("outside dataTaskWithURL")
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
    
    let post = self.posts[indexPath.row]
    cell.post = post
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
        
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
        // setting the compression quality to 90%
        if let imageData = UIImageJPEGRepresentation(image, 0.9),
            let imageFile = PFFile(data: imageData),
            let user = PFUser.current(){
            
            let post = Post(image: imageFile, user: user, comment: "A Selfie")
            
            post.saveInBackground(block: { (success, error) -> Void in
                if success {
                    print("Post successfully saved in Parse")
                    self.posts.insert(post, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            })
            
        }
    }
    dismiss(animated: true, completion: nil)


            
        
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
