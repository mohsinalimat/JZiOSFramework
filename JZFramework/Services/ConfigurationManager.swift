//
//  ConfigurationManager.swift
//  JZFramework
//
//  Created by Jeff Zhang on 13/3/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//


class ConfigurationManager {
    
    public enum Environment{
        case develop, test, live, release
    }
    
    public let properties:[String:Any]
    public var environment: Environment
    
    public init(environment:Environment) {
        self.environment = environment
        let frameworkBundle = Bundle(identifier: "com.zjfjack.JZFramework")
        var configFileName = ""
        switch environment {
        case .live:
//            configFileName = "config_live"
            break
        case .release:
            break
        case.test:
            break
        case .develop:
            configFileName = "config_dev"
        }
        
        if let path = frameworkBundle?.path(forResource: configFileName, ofType: "plist") {
            if let properties = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                self.properties = properties
            }
            else {
                fatalError("Failed to open the config file: " + configFileName)
            }
        }
        else {
            fatalError("Config file: " + configFileName + " is not found.")
        }
    }
    
    public static func getVersionAndBuild() -> (version: String, build: String) {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return (version, build)
    }
}
