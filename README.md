# NyTimes

Design Pattern Used :
MVVM - 
- For improving code testability
- Data binding - Observer.swift (Did not implement two way data binding to avoid 3rd party dependency such as RXSwift and RXCocoa)
- For having small sized View Controller
- For seperation of concern of View and business logic


Protocol Oriented Programming - 
- For writing loosely coupled code
- For creating Dependency Injection
- For code scalability


Dependency Injection - 
- Again for loosely coupled codes
- For creating Mock classes for testing APIServices without network
- Improving testability

Network Calls :-
NSURLSession - APIService.swift
- Have not considered other HTTP Requests like POST etc.
- Have kept class as simple as possible, related to our Demo
- Can be scaled to accomodate other kind of network calls



 
