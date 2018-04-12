import Foundation
import Jay
import HTTP

public class MessengerHelper {
    public static func postbackButtonFor(title: String, payload: String) -> [String: Any] {
        return ["type": "postback", "title": title, "payload": payload]
    }
    
    public static func genericUploadMessage(type: String, url: String) -> [String: Any] {
        return [
            "message": [
                "attachment": genericAttachment(type: type, url: url)
            ]
        ]
    }
    
    public static func uploadImageMessage(url: String) -> [String: Any] {
        return [
            "message": [
                "attachment":[
                    "type":"image",
                    "payload":
                        ["is_reusable": true,
                         "url": url
                    ]
                ]
            ]
        ]
    }

    public static func genericAttachment(type: String, url: String) -> [String: Any] {
        return [
            "type":type,
            "payload":
                ["is_reusable": true,
                 "url": url
            ]
        ]
    }
    
    public static func broadcastCreativeMessageJSON(title: String, imageUrl: String, subtitle: String, linkUrl: String, linkTitle: String) -> [String: Any] {
        let button = ["type": "web_url", "url": linkUrl, "title": linkTitle]
        let elements: [String : Any] = ["title": title,
                                        "subtitle": subtitle,
                                        "image_url": imageUrl,
                                        "buttons": [button]]
        let attachment = genericShortAttachment(elements: [elements])
        
        return ["messages": [attachment]]
    }
    
    public static func broadcastMessageJSON(messageCreativeId: String, notificationType: String, tag: String) -> [String: Any] {
        return ["message_creative_id": messageCreativeId,
                "notification_type": notificationType,
                "tag": tag
        ]
    }
    
    public static func mediaTemplateAttachment(attachmentId: String, type: String = "image", buttons: [[String: Any]]? = nil) -> [String: Any] {
        var elements: [String: Any] = ["media_type": type,
                                       "attachment_id": attachmentId]
        
        if let mediaButtons = buttons {
            elements["buttons"] = mediaButtons
        }
        
        return ["type": "template",
                "payload": [
                    "template_type": "media",
                    "elements": [elements]
            ]
        ]
    }
    
    public static func genericButtonsAttachment(message: String, buttons: [[String: Any]]) -> [String: Any] {
        return ["type": "template",
                "payload":
                    ["template_type": "button",
                     "text": message,
                     "buttons": buttons
            ]
        ]
    }
    
    public static func genericShortAttachment(elements: [[String: Any]]) -> [String: Any] {
        return ["attachment":
            ["type": "template",
             "payload":
                ["template_type": "generic",
                 "elements": elements
                ]
            ]
        ]
    }
    
    public static func genericAttachment(elements: [[String: Any]]) -> [String: Any] {
        return ["type": "template",
                "payload":
                    ["template_type": "generic",
//                     "image_aspect_ratio": "square",
                     "elements": elements
            ]
        ]
    }
    
    public static func listAttachment(elements: [[String: Any]]) -> [String: Any] {
        return ["type": "template",
                "payload":
                    ["template_type": "list",
                     "top_element_style": "LARGE",
                     "elements": elements
            ]
        ]
    }
    
    public static func buttonFor(zodiac: String, shouldChangeSign: Bool = false) -> [String: Any] {
        let title = "\(zodiac)"
        return ["type": "postback", "title": title, "payload": "\(zodiac)|\(shouldChangeSign)"]
    }
    
    public static func getElement(title: String, subtitle: String, buttons: [[String: Any]], imageUrl: String) -> [String: Any] {
        return ["title": title, "subtitle": subtitle, "buttons": buttons, "image_url": imageUrl]
    }

    public static func weblinkButtonTemplate(title: String, url: String) -> [String: Any] {
        return ["type": "web_url",
                "url": url,
                "title": title,
                "webview_height_ratio": "full",
                "messenger_extensions": true]
    }
}

