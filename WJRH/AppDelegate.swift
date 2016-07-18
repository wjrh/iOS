//
//  AppDelegate.swift
//  WJRH
//
//  Created by Eric Weber on 6/23/16.
//  Copyright © 2016 Eric Weber. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var libraryController: LibraryController?
    var tealInfo: TealInfo?
    var radioPlaying = false
    var radioMuted = false
    var episodePlaying = false
    
    var programTable: UITableView?
    var episodeTable: UITableView?
    
    private var radioPlayer = AVPlayer(URL: NSURL(string:"http://wjrh.org:8000/WJRHlow")!)
    private var episodePlayer = AVPlayer()
    
    func playRadio() {
        do {
            try AVAudioSession.sharedInstance().setCategory( AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
            radioPlayer.play()
            radioPlaying = true
        } catch {
            print("Failed to open stream")
        }
    }
    func stopRadio() {
        radioPlayer.rate = 0.0
        radioPlayer = AVPlayer(URL: NSURL(string:"http://wjrh.org:8000/WJRHlow")!)
        radioPlaying = false
    }
    func loadEpisode(episodeAudioURL: String) {
        episodePlayer = AVPlayer(URL: NSURL(string: episodeAudioURL)!)
    }
    func playEpisode() {
        episodePlayer.play()
        episodePlaying = true
    }
    func pauseEpisode() {
        episodePlayer.pause()
        episodePlaying = false
    }
    
    func reloadProgramTable() {
        if let programTableUnwrapped = programTable {
            dispatch_async(dispatch_get_main_queue(), {
                programTableUnwrapped.reloadSections(NSIndexSet(index: 0) , withRowAnimation: .Automatic)
            })
        }
    }
    func reloadEpisodeTable() {
        if let episodeTableUnwrapped = episodeTable {
            dispatch_async(dispatch_get_main_queue(), {
                episodeTableUnwrapped.reloadSections(NSIndexSet(index: 0) , withRowAnimation: .Automatic)
            })
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let tabController = self.window!.rootViewController as? UITabBarController
        libraryController = tabController!.viewControllers![1].childViewControllers[0] as? LibraryController
        tealInfo = TealInfo(imageLoadCallback: reloadProgramTable)//libraryController!.refreshLibraryTable)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

