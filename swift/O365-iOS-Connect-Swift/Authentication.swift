//
//  Authentication.swift
//  O365-iOS-Connect-Swift
//
//  Created by Siraset Jirapatchandej on 8/26/2559 BE.
//  Copyright © 2559 Microsoft. All rights reserved.
//

import Foundation

class Authentication {
    // This value must match the value used when registering the app
    let redirectURL = NSURL(string: "urn:ietf:wg:oauth:2.0:oob")
    // The Azure OAuth2 authority
    let authority = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
    // The resource identifier for the Outlook APIs
    let outlookResource = "https://outlook.office365.com"
    // The client ID obtained by registering the app
    let clientId = "768cda8a-6a82-49ed-bcda-00f71fe08cbe"
    // ADAL dependency resolver, used to enable logon UI
    var dependencyResolver = ADALDependencyResolver()
    
    // Create a singleton instance of the AuthenticationManager
    // class. The app uses this instance for all operations.
    class var sharedInstance: Authentication {
        struct Singleton {
            static let instance = Authentication()
        }
        
        return Singleton.instance
    }
    
    // Asynchronous function to retrieve a token. This will load the
    // token from the cache (if present), otherwise it will use
    // ADAL to prompt the user to sign into Azure.
    func getToken(completionHandler:((Bool, String) -> Void)) {
        var err: ADAuthenticationError?
        let authContext: ADAuthenticationContext = ADAuthenticationContext(authority: authority,
                                                                           error: &err)
        
        // Acquire the token. This will prompt the user to login if there is not
        // a valid token already in the app's cache.
        /*
        authContext.acquireTokenWithResource(outlookResource, clientId: clientId, redirectUri: redirectURL as URL!) {
            (result: ADAuthenticationResult!) -> Void in
            
            if result.status.value != AD_SUCCEEDED.value {
                // Failed, return error description
                completionHandler(false, result.error.description)
            }
            else {
                // Succeeded, return the acess token
                var token = result.accessToken
                // Initialize the dependency resolver with the logged on context.
                // The dependency resolver is passed to the Outlook library.
                self.dependencyResolver = ADALDependencyResolver(context: authContext, resourceId: self.outlookResource, clientId: self.clientId, redirectUri: self.redirectURL)
                completionHandler(true, token)
            }
        }
        */
        
        authContext.acquireToken(withResource: outlookResource, clientId: clientId, redirectUri: redirectURL as URL!) { (result:ADAuthenticationResult?) in
            
            if result?.status.rawValue != AD_SUCCEEDED.rawValue {
                // Failed, return error description
                completionHandler(false, (result?.error.description)!)
            }
            else {
                // Succeeded, return the acess token
                var token = result?.accessToken
                // Initialize the dependency resolver with the logged on context.
                // The dependency resolver is passed to the Outlook library.
                self.dependencyResolver = ADALDependencyResolver(context: authContext, resourceId: self.outlookResource, clientId: self.clientId, redirectUri: self.redirectURL as URL!)
                completionHandler(true, token!)
            }
        }
        
        
    }
    
    // Logout function to clear the app's cache and remove the user's information.
    func logout() {
        var error: ADAuthenticationError?
        let cache: ADTokenCacheStoring = ADAuthenticationSettings.sharedInstance().defaultTokenCacheStore
        
        // Clear the token cache
        let allItemsArray = cache.allItemsWithError(&error)
        if (!(allItemsArray?.isEmpty)!) {
            cache.removeAllWithError(&error)
        }
        
        // Remove all the cookies from this application's sandbox. The authorization code is stored in the
        // cookies and ADAL will try to get to access tokens based on auth code in the cookie.
        let cookieStore = HTTPCookieStorage.shared
        if let cookies = cookieStore.cookies {
            for cookie in cookies {
                cookieStore.deleteCookie(cookie)
            }
        }
    }
}
