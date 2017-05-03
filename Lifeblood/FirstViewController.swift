//
//  FirstViewController.swift
//  Lifeblood
//
//  Created by Bryan Tong on 4/13/17.
//  Copyright © 2017 btong. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dbRef = FIRDatabase.database().reference()
    
    let localUser = LocalUser()

    @IBOutlet weak var matchesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesTableView.delegate = self
        matchesTableView.dataSource = self
        //getMatches(user: LocalUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*func getMatches(user: LocalUser) -> Void) {
    dbRef.child("users").observeSingleEvent(of: .value, with: { (user) in
            if user.exists() {
                if let dict: [String:AnyObject] = user.value as! [String : AnyObject]? {
                    user.getReadPostIDs (completion: { (snaps) in
                        for (key, value) in dict {
                            let postRead = snaps.contains(key)
                            let posting = Post(id: key,
                                               username: value[firUsernameNode] as! String,
                                               postImagePath: value[firImagePathNode] as! String,
                                               thread: value[firThreadNode] as! String,
                                               dateString: value[firDateNode] as! String,
                                               read: postRead)
                            postArray.append(posting)
                        }
                        completion(postArray)
                    } )
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
            
            
        } )
        
    }*/

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        dbRef.child("users").observeSingleEvent(of: .value, with: { (user) in
            if user.exists() {
                count += 1
            }
        })
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchFirstViewCell
        cell.bloodTypeLabel.text = "O+"
        cell.nameAndLocation.text = "Test Tester from 94704"
        /*if let post = getPostFromIndexPath(indexPath: indexPath) {
            if post.read {
                cell.readImageView.image = UIImage(named: "read")
            }
            else {
                cell.readImageView.image = UIImage(named: "unread")
            }
            cell.usernameLabel.text = post.username
            cell.timeElapsedLabel.text = post.getTimeElapsedString()
        }*/
        return cell
    }

}

