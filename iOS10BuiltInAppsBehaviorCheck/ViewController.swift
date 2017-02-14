//
//  ViewController.swift
//  iOS10BuiltInAppsBehaviorCheck
//
//  Created by hiraya.shingo on 2017/02/13.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import UIKit
import MessageUI
import EventKit
import EventKitUI
import ContactsUI

class ViewController: UIViewController {
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventStore.requestAccess(to: .event) { success, error in
            print("event Access request", (success ? "success" : "failure"))
        }
        
        eventStore.requestAccess(to: .reminder) { success, error in
            print("reminder Access request", (success ? "success" : "failure"))
        }
    }

    @IBAction func didTapMailButton(_ sender: Any) {
        print(#function)
        openURL(url: URL(string: "mailto:foo@example.com")!)
    }
    
    @IBAction func didTapMailComposeButton(_ sender: Any) {
        print(#function)
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["foo@example.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello from Japan!", isHTML: false)
        present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapCalendarButton(_ sender: Any) {
        print(#function)
        
        let event = EKEvent(eventStore: eventStore)
        event.title = "New Event"
        
        let eventEditVC = EKEventEditViewController()
        eventEditVC.eventStore = eventStore
        eventEditVC.event = event
        eventEditVC.editViewDelegate = self
        present(eventEditVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapReminderButton(_ sender: Any) {
        print(#function)
        
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = "New Reminder"
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        try! eventStore.save(reminder, commit: true)
    }
    
    @IBAction func didTapContactsButton(_ sender: Any) {
        print(#function)
        let picker = CNContactPickerViewController()
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didTapMusicButton(_ sender: Any) {
        print(#function)
        openURL(url: URL(string: "https://itunes.apple.com/jp/album/24k-magic/id1161503945")!)
    }
    
    @IBAction func didTapITunesButton(_ sender: Any) {
        print(#function)
        openURL(url: URL(string: "https://geo.itunes.apple.com/jp/album/jupiter/id201478063?app=itunes")!)
    }
    
    @IBAction func didTapIBooksButton(_ sender: Any) {
        print(#function)
        openURL(url: URL(string: "https://itunes.apple.com/jp/book/swift-programming-language/id881256329?mt=11")!)
    }
    
    @IBAction func didTapMapButton(_ sender: Any) {
        print(#function)
        openURL(url: URL(string: "http://maps.apple.com/?ll=50.894967,4.341626")!)
    }
    
    @IBAction func didTapFaceTimeButton(_ sender: Any) {
        print(#function)
        openURL(url: URL(string: "facetime://foo@example.com")!)
    }
    
    func openURL(url: URL) {
        if (UIApplication.shared.canOpenURL(url)) {
            print("can Open URL", url)
            UIApplication.shared.open(url)
        } else {
            print("CANNOT Open URL", url)
        }
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .saved:
            try! eventStore.save(controller.event!, span: .thisEvent)
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
}
