//
//  datastoreLoadTestingApp.swift
//  datastoreLoadTesting
//
//  Created by Law, Michael on 3/24/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins
@main
struct datastoreLoadTestingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Amplify.Logging.logLevel = .verbose
        do {
        // AmplifyModels is generated in the previous step
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSAPIPlugin())
        try Amplify.configure()
        print("Amplify configured with DataStore plugin")
    } catch {
        print("Failed to initialize Amplify with \(error)")
        return false
    }

        return true
    }
}
