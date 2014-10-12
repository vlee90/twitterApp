// Playground - noun: a place where people can play

import UIKit

// Queue

class Queue {
    var queue = [String]()
    
    func enqueue(enqueString: String) {
        self.queue.append(enqueString)
    }

    func dequeue() ->String? {
        if !queue.isEmpty {
            var dequeueString = queue.first
            queue.removeAtIndex(0)
            return dequeueString
        }
        else {
            return nil
        }
    }
}

// Stack

class Stack {
    var stack = [String]()
    
    func push(pushString: String) {
        self.stack.append(pushString)
    }
    
    func pop() -> String? {
        if !self.stack.isEmpty {
            var returnString = self.stack.last
            self.stack.removeLast()
            return returnString
        }
        else {
            return nil
        }
    }
}