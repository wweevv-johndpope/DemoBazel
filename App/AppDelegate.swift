//
//  AppDelegate.swift
//  DemoProjectBazel
//
//  Created by Thanh Vu on 16/07/2021.
//

import UIKit
import Supabase
import PostgREST
import Realtime
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    private var client:SupabaseClient?
    var database:PostgrestClient?
    var realtimeClient:RealtimeClient?
    
    private let supabaseUrl = "https://pqxcxltwoifmxcmhghzf.supabase.co"
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBxeGN4bHR3b2lmbXhjbWhnaHpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjAxODczNDQsImV4cCI6MTk3NTc2MzM0NH0.NiufAQmZ3Oy7eP7wNWF-tvH-e2D-UIz-vPLpLAyDMow"


    struct TestClass: Codable {
        var id: Int?
    }
    
    var allUsersUpdateChanges:Realtime.Channel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()

    

        let rt = RealtimeClient(endPoint: "https://pqxcxltwoifmxcmhghzf.supabase.co/realtime/v1", params: ["apikey": supabaseKey])
        rt.connect()
        rt.onOpen {
           
            self.allUsersUpdateChanges =  rt.channel(.all)//rt.channel(.table("test", schema: "public"))
            self.allUsersUpdateChanges?.on(.all) { message in
                print("☕️")
                print(message.payload)
                print(message.event)
                print(message.status)
            }
            self.allUsersUpdateChanges?.subscribe()
        }
        self.realtimeClient = rt
        self.realtimeClient?.onError{error in
            print("🔥 error")
            print(error)
        }
        self.realtimeClient?.onMessage{message in
            print("🔖 message")
            print(message.payload)
            print(message.event)
            print(message.status)
//            print(message.joinRef)
            
        }
      
//        allUsersUpdateChanges.unsubscribe()
//        allUsersUpdateChanges.off(.update)
        
               let client = SupabaseClient(supabaseURL:URL(string: supabaseUrl)!, supabaseKey: supabaseKey)
                let database = PostgrestClient(url: "\(supabaseUrl)/rest/v1", headers: ["apikey":supabaseKey], schema: "public")
        //
                self.client = client
                self.database = database
        //
                self.database?.from("test").select().execute() { result in
                    switch result {
                    case let .success(response):
                        do {
                            let feedback = try response.decoded(to: [TestClass].self)
                            print(feedback)
                        } catch {
                            print(error.localizedDescription)
                        }
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
        //

        
        return true
    }

}

