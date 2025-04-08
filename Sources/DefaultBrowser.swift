// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import AppKit
import Foundation

@available(macOS 12.0, *)
@main
struct DefaultBrowser: AsyncParsableCommand {
    @Argument(help: "Default browser to set")
    var browser: String? = nil
    
    mutating func run() async throws {
        let httpUrl = URL(string: "http://www.apple.com")!
        let browsers = NSWorkspace.shared.urlsForApplications(toOpen: httpUrl)
        
        if browser == nil {
            printBrowsers(forUrl: httpUrl, browsers:browsers)
            return
        }
        
        if let browserUrl = browsers.first(where: {formatBrowserName(browser: $0) == browser}) {
            NSWorkspace.shared.setDefaultApplication(at: browserUrl, toOpenURLsWithScheme: "http"){ error in
                if let error = error {
                    DefaultBrowser.exit(withError: error)
                } else {
                    DefaultBrowser.exit()
                }
            }
            
            
            if let scriptObject = NSAppleScript(source: """
try
tell application "System Events"
tell application process "CoreServicesUIAgent"
tell window 1
  tell (first button whose name starts with "use")
    perform action "AXPress"
  end tell
end tell
end tell
end tell
end try
""") {
                scriptObject.executeAndReturnError(nil)
            }
        } else {
            print("Invalid browser, use one of these")
            printBrowsers(forUrl: httpUrl, browsers: browsers)
        }
    }
    
    func formatBrowserName(browser: URL) -> String {
        return (browser.lastPathComponent as NSString).deletingPathExtension.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
    func printBrowsers(forUrl: URL, browsers: [URL]) -> Void {
        let current = NSWorkspace.shared.urlForApplication(toOpen: forUrl)!
        let sorted = browsers.sorted { $0.path < $1.path }
        sorted.forEach { browser in
            if browser == current {
                print("*", formatBrowserName( browser: browser))
            } else {
                print(formatBrowserName(browser: browser))
            }
        }
    }
}
