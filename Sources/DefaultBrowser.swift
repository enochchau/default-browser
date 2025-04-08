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
        let browsers = getBrowsers(forUrl: httpUrl)
        
        if browser == nil {
            printBrowsers(forUrl: httpUrl, browsers:browsers)
            return
        }
        
        if let browserUrl = browsers.first(where: {formatBrowserName(browser: $0) == browser}) {
            do {
                try await setDefaultBrowser(browser: browserUrl)
            } catch {
                DefaultBrowser.exit(withError: error)
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
    
    func getBrowsers(forUrl: URL) -> [URL] {
        return NSWorkspace.shared.urlsForApplications(toOpen: forUrl)
        
    }
    
    func setDefaultBrowser(browser: URL) async throws {
        return try await NSWorkspace.shared.setDefaultApplication(at: browser, toOpenURLsWithScheme: "http")
    }
}
