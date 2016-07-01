//
//  Constants.swift
//  Vimeo Browser
//
//  Created by Martin Kelly on 30/06/2016.
//  Copyright © 2016 Martin Kelly. All rights reserved.
//

import Foundation

extension BaseClient {
    
    struct VimeoAPI {
        static let ClientIdentifier = ""
        static let ClientSecrets = ""
        static let AuthorizeUrl = "https://api.vimeo.com/oauth/authorize"
        static let BaseUrl = "https://api.vimeo.com/"
        static let AccessTokenUrl = "https://api.vimeo.com/oauth/access_token"
        static let UnauthorizedAccessTokenUrl = "https://api.vimeo.com/oauth/authorize/client"
        static let VimeoTokenGrantType = "client_credentials"
    }
    
    struct Constants {
        static let CategoryImageWidth = 960
        static let CategoryImageHeight = 540
    }
    
    struct Keys {
        
        // Vimeo 
        static let VimeoGrantType = "grant_type"
        static let VimeoAccessToken = "access_token"
        
        struct Category {
            static let ResourceKey = "resource_key"
            static let Name = "name"
            static let Uri = "uri"
            static let Link = "link"
            static let TopLevel = "top_level"
            static let Pictures = "pictures"
            static let PicturesWidth = "width"
            static let PicturesHeight = "height"
            static let PicturesLink = "link"
            static let PicturesLinkWithPlayIcon = "link_with_play_button"
        }
    }
    
    struct Methods {
        static let CategoriesMethod = "categories"
    }
}