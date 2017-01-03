//
//  TestClassesAndStructs.swift
//  SilverIntro
//
//  Created by Taras Vozniuk on 22/12/2016.
//  Copyright © 2016 Ambientlight. All rights reserved.
//

#if COOPER
    import remobjects.elements.eunit
    //UUID
    import java.util
#else
    import XCTest
    import Foundation
#endif

extension UUID {
    
    #if COOPER
    
    public init(){
        return UUID.randomUUID()
    }
    
    public var uuidString: String {
        return self.toString()
    }
    
    #endif
}

public class MapEntity {
    
    public private(set) var identifier: String
    public private(set) var tags: [String: String]
    
    public private(set) var versionº: String?
    public private(set) var changesetIdº: String?
    public let visibleº: String?
    public let timestampº: String?
    public let userº: String?
    public let uidº: String?
    
    public init(tags: [String: String]){
        
        self.identifier = UUID().uuidString
        self.tags = tags
        
        self.visibleº = nil
        self.versionº = nil
        self.changesetIdº = nil
        self.timestampº = nil
        self.userº = nil
        self.uidº = nil
    }
    
    public static func empty(with identifier: String) -> MapEntity {
        let targetEntity = MapEntity(tags: [:])
        targetEntity.identifier = identifier
        return targetEntity
    }
    
    public subscript(tagIndex: Int) -> String? {
        guard tagIndex < self.tags.values.count else {
            return nil
        }
        
        #if COOPER
            return [String](sequence: self.tags.values)[tagIndex]
        #else
            return [String](self.tags.values)[tagIndex]
        #endif
    }
}

extension MapEntity: Equatable {
    public static func ==(lhs: MapEntity, rhs: MapEntity) -> Bool {
        return (lhs.identifier == rhs.identifier)
    }
    
    #if COOPER
    public override func equals(_ o: Object!) -> Bool {
        
        guard let other = o as? Self else {
            return false
        }
        
        return (self == other)
    }
    #endif
}

extension MapEntity: Hashable {
    public var hashValue:Int {
        return "\(self.identifier)".hashValue
    }
    
    #if COOPER
    public override func hashCode() -> Int32 {
        return "\(self.identifier)".hashCode()
    }
    #endif
}

public class MapNode: MapEntity {
    
    public private(set) var longitude: Double
    public private(set) var latitude: Double
    
    public init(longitude: Double, latitude: Double, tags: [String: String]){
        #if COOPER
        super.init(tags: tags)
        #endif
        
        self.longitude = longitude
        self.latitude = latitude
        
        #if !COOPER
        super.init(tags: tags)
        #endif
    }
}

public class TestClasses: Test {

    public func testClasses(){
        
        let anfield = MapNode(longitude: -2.9617323, latitude: 53.4301056,
                              tags: ["leisure": "stadium",
                                     "sport": "soccer",
                                     "name": "Anfield"])
        
        Assert.AreEqual(anfield[0] ?? String(), "Anfield")
        Assert.AreEqual(anfield, MapEntity.empty(with: anfield.identifier))
        
        let appleCampus2 = MapNode(longitude: -122.0086468, latitude: 37.3327147,
                                  tags: ["building": "construction",
                                         "name":"Apple Campus 2"])
        
        
        let nodeDict = [anfield: "This is anfield",
                        appleCampus2: "The fanciest circular structure (only McLaren guys will doubt that)"
                        //,MapEntity.empty(with: anfield.identifier): "this should override anfield"
                        ]
        Assert.AreEqual(nodeDict.values.count, 2)
        //Assert.AreEqual(nodeDict[anfield] ?? "", "this should override anfield")
        
    }
}
