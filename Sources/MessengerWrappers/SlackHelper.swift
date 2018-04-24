//
//  SlackHelper.swift
//  MessengerWrappersPackageDescription
//
//  Created by Dmitry Valov on 13.04.2018.
//

import Foundation
import Vapor
import HTTP
import Dispatch

public class SlackHelper {
    
    let client: Vapor.Responder

    public init(client: Vapor.Responder) {
        self.client = client
    }
    
    public func sendTextToSlack(_ text: String, host: String, sync: Bool = false) {
        let slackHeaders: [HeaderKey: String] = [
            "Content-Type": "application/json; charset=UTF-8"
        ]
        let body = "{\"text\":\"\(text)\"}".makeBody()
        
        if sync {
            self.syncPostRequestTo(host: host, headers: slackHeaders, body: body)
        } else {
            self.asyncPostRequestTo(host: host, headers: slackHeaders, body: body)
        }
    }
    
    public func sendFileToSlack(content: String,
                         token: String,
                         channels: String,
                         filetype: String,
                         filename: String,
                         sync: Bool = false) {
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        let host = "https://slack.com/api/files.upload"
        let slackHeaders: [HeaderKey: String] = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        let parameters = [
            "content": content,
            "token": token,
            "channels": channels,
            "filetype": filetype,
            "filename": filename
        ]
        let body = self.createMultipartFormBody(with: parameters, boundary: boundary)
        
        if sync {
            self.syncPostRequestTo(host: host, headers: slackHeaders, body: body)

        } else {
            self.asyncPostRequestTo(host: host, headers: slackHeaders, body: body)
        }
    }
    
    @discardableResult
    public func syncPostRequestTo(host: String, headers: [HeaderKey: String], body: BodyRepresentable) -> (Response?, Error?) {
        do {
            let result = try self.client.post(host, query: [:], headers, body, through: [])
            if result.status != .ok {
                 print("Failed to get 200 when posting to \(host), response=\(result)")
            }
            return (result, nil)
        } catch let error {
            print("Hit error when posting to \(host), error=\(error)")
            return (nil, error)
        }
    }
    
    public func asyncPostRequestTo(host: String, headers: [HeaderKey: String], body: BodyRepresentable) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [weak self] in
            guard let welf = self else {
                return
            }
            welf.syncPostRequestTo(host: host, headers: headers, body: body)
        }
    }
    
    public func createMultipartFormBody(with parameters: [String: Any], boundary: String) -> String {
        var body = ""
        let separatorBoundary = "--\(boundary)\r\n"
        let finalBoundary = "--\(boundary)--\r\n"
        
        for (key, value) in parameters {
            body.append(separatorBoundary)
            var valueString: String
            if let boolValue = value as? Bool {
                valueString = String(boolValue)
            } else {
                valueString = String(describing: value)
            }
            
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(valueString)\r\n")
        }
        body.append(finalBoundary)
        return body
    }
}
