//
//  TestEnums.swift
//  SilverIntro
//
//  Created by Taras Vozniuk on 20/12/2016.
//  Copyright © 2016 Ambientlight. All rights reserved.
//

#if COOPER
    import remobjects.elements.eunit
#else
    import XCTest
#endif

enum SolarSystem: String {
    case sun
    case mercury
    case venus
    case earth
    
    var distanceToEarth: Int {
        switch self {
        case .sun: return 149600000
        case .mercury: return 77000000
        case .venus: return 40000000
        case .earth: return 0
        }
    }
}

enum Callback<T> {
    case error(Error)
    case success(T)
}

public class TestEnums: Test {
    
    public func enumTests(){
        
        let earth = SolarSystem.earth
        print(earth.rawValue)
        print("Distance from the sun: \(SolarSystem.sun.distanceToEarth)")
    }
    
    public func enumTestThatFails(){
        
        let callback = Callback<String>.success("seems to be working")
        
        //will result in [NullPointerException] in silver:
        //Attempt to write to field 'int silverintro.Callback.fValue' on a null object reference
        print(callback)
        //the compiler will likely crash in the next code in Silver
        #if !COOPER
            switch callback {
            case .error(let error): print("Callback with error: \(error)")
            case .success(let result): print("Succesful callback: \(result)")
            }
        #endif
    }
}
