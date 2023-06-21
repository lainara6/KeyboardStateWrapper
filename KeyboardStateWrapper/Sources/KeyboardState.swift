//
//  KeyboardState.swift
//  KeyboardStateWrapper
//
//  Created by Lay Channara on 6/21/23.
//

import UIKit

@propertyWrapper
final class KeyboardState {
    
    enum State {
        case will
        case did
    }
    
    private var showNotificationName: Notification.Name
    private var hideNotificationName: Notification.Name
    private var showHandler: (([String: Any]?, Bool) -> ())?
    private(set) var wrappedValue: CGFloat = 0
    
    var projectedValue: (@escaping ([String: Any]?, Bool) -> ()) -> () {
        { [weak self] in
            self?.showHandler = $0
        }
    }
    
    init(state: State) {
        showNotificationName = state == .will ? UIResponder.keyboardWillShowNotification : UIResponder.keyboardDidShowNotification
        hideNotificationName = state == .will ? UIResponder.keyboardWillHideNotification : UIResponder.keyboardDidHideNotification
        
        [showNotificationName, hideNotificationName].forEach {
            NotificationCenter.default.addObserver(forName: $0, object: nil, queue: nil) { notification in
                let userInfo = notification.userInfo as? [String: Any]
                let show = notification.name == self.showNotificationName
                self.wrappedValue = show ? (userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect)?.height ?? 0 : 0
                self.showHandler?(userInfo, show)
            }
        }
    }
    
    deinit {
        [showNotificationName, hideNotificationName].forEach {
            NotificationCenter.default.removeObserver(self, name: $0, object: nil)
        }
    }
}
