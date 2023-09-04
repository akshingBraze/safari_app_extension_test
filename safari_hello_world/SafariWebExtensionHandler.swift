//
//  SafariWebExtensionHandler.swift
//  safari_hello_world
//
//  Created by Akshin Goswami on 13/8/2023.
//

import SafariServices
import os.log
import BrazeKit

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    static var braze: Braze? = nil

    override init() {
        var configuration = Braze.Configuration(
            apiKey: "cfc33818-62c6-4ebb-9b2b-896a1aca9b38",
            endpoint: "sdk.iad-03.braze.com"
        )
        var braze = Braze(configuration: configuration)
        SafariWebExtensionHandler.braze = braze
    }

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]

        context.completeRequest(returningItems: [response], completionHandler: nil)
        
        // some random data for Braze
        SafariWebExtensionHandler.braze?.changeUser(userId: "SafariAbc123")
        SafariWebExtensionHandler.braze?.logCustomEvent(name: "extension_event")
        SafariWebExtensionHandler.braze?.requestImmediateDataFlush()
        print("Safari Web Extension Finished")
        // some content cards for Braze
    }
    
    

}
