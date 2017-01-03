//
//  TestProtocolsAndGenerics.swift
//  LakestoneCore
//
//  Created by Taras Vozniuk on 9/22/16.
//  Copyright © 2016 GeoThings. All rights reserved.
//
// --------------------------------------------------------
//

#if COOPER
	import remobjects.elements.eunit
#else
	import XCTest
#endif

#if COOPER
	typealias DoubleProxy = BoxedDouble
#else
	typealias DoubleProxy = Double
#endif

public class BoxedDouble {
	fileprivate var underlyingValue: Double
	
	init(_ value: Double){
		self.underlyingValue = value
	}
}

extension BoxedDouble: Equatable {
	
	public static func ==(lhs: BoxedDouble, rhs: BoxedDouble) -> Bool {
		return lhs.underlyingValue == rhs.underlyingValue
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

public class Coordinate<T: Equatable> {
	//might be longitude
	public var x: T
	//might be latitude
	public var y: T
	
	public init(x: T, y: T){
		self.x = x
		self.y = y
	}
}

extension Coordinate: Equatable {
	public static func ==(lhs: Coordinate<T>, rhs: Coordinate<T>) -> Bool {
		
		#if COOPER
			//lhs.x == rhs.x && lhs.y == rhs.y won't work on generic type
			
			return (
			   lhs.x.getClass().getDeclaredMethod("op_Equality", [lhs.x.getClass(), rhs.x.getClass()]).invoke(nil, [lhs.x, rhs.x]) as! Bool
			   &&
			   lhs.y.getClass().getDeclaredMethod("op_Equality", [lhs.y.getClass(), rhs.y.getClass()]).invoke(nil, [lhs.y, rhs.y]) as! Bool
			)
			
		#else
			return lhs.x == rhs.x && lhs.y == rhs.y
		#endif
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

public class TestProtocolsAndGenerics: Test {
	
	public func testProtocolsAndGenerics(){
		
		let coordinate1 = Coordinate<DoubleProxy>(x: DoubleProxy(2.0), y: DoubleProxy(5.0))
		let coordinate2 = Coordinate<DoubleProxy>(x: DoubleProxy(2.0), y: DoubleProxy(5.0))
		let coordinate3 = Coordinate<DoubleProxy>(x: DoubleProxy(3.0), y: DoubleProxy(5.0))
		Assert.AreEqual(coordinate1, coordinate2)
		Assert.AreNotEqual(coordinate1, coordinate3)
	}
}
