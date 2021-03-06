//
//  MainTableViewController.swift
//  Vimeo Browser
//
//  Created by Martin Kelly on 10/07/2016.
//  Copyright © 2016 Martin Kelly. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var selectedVideo:Video?
    
    // MARK: Core Data Helpers
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetch = NSFetchRequest(entityName: "Video")
        let sort = NSSortDescriptor(key: "createdTime", ascending: false)
        fetch.sortDescriptors = [sort]
        fetch.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: Convenience Properties
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func loadData() {
        
        DataManager.sharedInstance().loadData() { success in
            
            if !success {
                print("Load data failed")
                
                self.displayQuickAlert("ERROR!", message: "An error occurred when trying to connect to Vimeo. You will only be able to browse local data. Please restart your app to retry for the latest content")
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.loadData), forControlEvents: [.ValueChanged])
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching the latest content")
        
        tableView.addSubview(refreshControl)
        
        loadData()
        
        tableView.registerNib(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: VimeoClient.Constants.videoCellIdentifier)
        
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch let error {
            print("Fetch error in MainTableViewController: \(error)")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == VimeoClient.Constants.ShowVideoSegueIdentifier {
            
            if let vc = segue.destinationViewController as? VideoViewController, let video = selectedVideo {
                vc.video = video
            }
        }
    }
    
    @IBAction func refreshData(sender: UIBarButtonItem) {
        
        self.loadData()
    }
}

extension MainTableViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedVideo = (fetchedResultsController.objectAtIndexPath(indexPath) as! Video)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(VimeoClient.Constants.ShowVideoSegueIdentifier, sender: self)
    }
}

extension MainTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let video = fetchedResultsController.objectAtIndexPath(indexPath) as! Video
        
        let cell = tableView.dequeueReusableCellWithIdentifier(VimeoClient.Constants.videoCellIdentifier) as! VideoCell
        cell.setVideoContent(video)
        
        return cell
    }
}

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        default:
            break
        }
    }
}
