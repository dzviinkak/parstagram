//
//  FeedViewController.swift
//  parstagram
//
//  Created by Dzvinka Koman on 10/18/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // creates an emply array of pfobjects
    var posts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    // makes table view refresh
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // used parse ios documentation for basic queries to get this code
        let query = PFQuery(className:"Posts")
        // adds actual objects (and not just pointer) into the posts table on parse (in the field owner)
        query.includeKey("author")
        query.limit = 20
        
        // stores data
        query.findObjectsInBackground(block: {(posts, error) in
            if posts != nil {
                // add data into array
                self.posts = posts!
                // refresh
                self.tableView.reloadData()
            } })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell ") as! PostCell
        // gets one specific post
        // configure the process of getting the username of the person posting image into the feed
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        // configure the process of getting the caption of the image into the feed
        cell.usernameLabel.text = user.username
        cell.commentLabel.text = post["caption"] as! String
        // configure the process of pasting the image into the feed
        // initializes imageFile by retrieving it from table on parse
        let imageFile = post["image"] as! PFFileObject
        // creates url for imageFile
        let urlString = imageFile.url!
        // creates URL using built-in url constrictor
        let url = URL(string: urlString)!
        // uses alamofireImage to set image using url created
        cell.photoView.af_setImage(withURL: url)
        // after configuring the image, change the settings in info.list to alloow http images
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
