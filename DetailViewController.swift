//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Andrei Gurau on 1/18/16.
//  Copyright © 2016 Andrei Gurau. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var movie: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(movie)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y +  infoView.frame.size.height)
        // Do any additional setup after loading the view.
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overViewLabel.text = overview
        overViewLabel.sizeToFit()
        if let posterPath = movie["poster_path"] as? String
        {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            
            posterImageView.setImageWithURL(imageUrl!)
        }
        self.navigationItem.title = title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
