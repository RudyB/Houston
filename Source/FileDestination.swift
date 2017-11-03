//
//  FileDestination.swift
//  Houston
//
//  Created by Rudy Bermudez on 11/2/17.
//  Copyright © 2017 Houston. All rights reserved.
//

import Foundation

public class FileDestination: BaseDestination {
	
	public var logFileURL: URL?
	
	override public var defaultHashValue: Int {return 2}
	let fileManager = FileManager.default
	var fileHandle: FileHandle?
	
	public override init() {
		var baseURL: URL?
		#if os(OSX)
			if let url = fileManager.urls(for:.cachesDirectory, in: .userDomainMask).first {
				baseURL = url
				// try to use ~/Library/Caches/APP NAME instead of ~/Library/Caches
				if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String {
					do {
						if let appURL = baseURL?.appendingPathComponent(appName, isDirectory: true) {
							try fileManager.createDirectory(at: appURL,
							                                withIntermediateDirectories: true, attributes: nil)
							baseURL = appURL
						}
					} catch {
						print("Warning! Could not create folder /Library/Caches/\(appName)")
					}
				}
		}
		#else
			// iOS, watchOS, etc. are using the document directory
			if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
				baseURL = url
			}
		#endif
	
		if let baseURL = baseURL {
			logFileURL = baseURL.appendingPathComponent("houston.log", isDirectory: false)
		}
		super.init()
	}
	
	override public func acceptLog(_ level: LogLevel, function: String, file: String, line: Int, message: String) -> String? {
		let formattedString = super.acceptLog(level, function: function, file: file, line: line, message: message)
		
		if let str = formattedString {
			_ = saveToFile(str)
		}
		
		return formattedString
	}
	
	func saveToFile(_ message: String) -> Bool {
		guard let url = logFileURL else { return false }
		do {
			if fileManager.fileExists(atPath: url.path) == false {
				// create file if not existing
				let line = message + "\n"
				try line.write(to: url, atomically: true, encoding: .utf8)
				
			} else {
				// append to end of file
				if fileHandle == nil {
					// initial setting of file handle
					fileHandle = try FileHandle(forWritingTo: url as URL)
				}
				if let fileHandle = fileHandle {
					_ = fileHandle.seekToEndOfFile()
					let line = message + "\n"
					if let data = line.data(using: String.Encoding.utf8) {
						fileHandle.write(data)
					}
				}
			}
			return true
		} catch {
			print("Houston File Destination could not write to file \(url).")
			return false
		}
	}
	
	/// deletes log file.
	/// returns true if file was removed or does not exist, false otherwise
	public func deleteLogFile() -> Bool {
		guard let url = logFileURL, fileManager.fileExists(atPath: url.path) == true else { return true }
		do {
			try fileManager.removeItem(at: url)
			fileHandle = nil
			return true
		} catch {
			print("Houston File Destination could not remove file \(url).")
			return false
		}
	}
}
