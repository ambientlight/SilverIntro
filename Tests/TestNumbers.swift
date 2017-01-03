//
//  TestNumbers.swift
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

// silver numeric types do not have a string initializer
// instead adding needed methods on String 
public extension String {
	
	public var integerRepresentation: Int? {
		#if COOPER
			return try? Int.parseLong(self)
		#else
			return Int(self)
		#endif
	}
	
	public var doubleRepresentation: Double? {
		#if COOPER
			return try? Double.parseDouble(self)
		#else
			return Double(self)
		#endif
	}
}

#if COOPER
// type(of:) is not available in silver by default
public func type<T>(of object: T?) -> Class<T>? {
	return (object != nil) ? object.Class : nil
}
#endif

public class TestNumbers: Test {
	
	public func testNumbericTypesMapping(){
		
		let optionalByte: Int8? = 0
		let optionalUbyte: UInt8? = 0
		let optionalShort: Int16? = 0
		let optionalUshort: UInt16? = 0
		let optionalInt: Int32? = 0
		let optionalUInt: UInt32? = 0
		let optionalLong: Int64? = 0
		let optionalULong: UInt64? = 0
		let optionalSigned: Int? = 0
		let optionalUnsigned: UInt? = 0
		let optionalFloat: Float? = 0
		let optionalDouble: Double? = 0
		
		//byte, class java.lang.Byte
		
		print("Int8: \(Int8.self), Int8?: \(type(of: optionalByte))")
		//byte, class com.remobjects.elements.system.UnsignedByte
		print("UInt8: \(UInt8.self), UInt8?: \(type(of: optionalUbyte))")
		//short, class java.lang.Short
		print("Int16: \(Int16.self), Int16?: \(type(of: optionalShort))")
		//short, class com.remobjects.elements.system.UnsignedShort
		print("UInt16: \(UInt16.self), UInt16?: \(type(of: optionalUshort))")
		//int, class java.lang.Integer
		print("Int32: \(Int32.self), Int32?: \(type(of: optionalInt))")
		//int, class com.remobjects.elements.system.UnsignedInteger
		print("UInt32: \(UInt32.self), UInt32?: \(type(of: optionalUInt))")
		//long, class java.lang.Long
		print("Int64: \(Int64.self), Int64?: \(type(of: optionalLong))")
		//long, class com.remobjects.elements.system.UnsignedLong
		print("UInt64: \(UInt64.self), UInt64?: \(type(of: optionalULong))")
		//long, class java.lang.Long
		print("Int: \(Int.self), Int?: \(type(of: optionalSigned))")
		//long, class com.remobjects.elements.system.UnsignedLong
		print("UInt: \(UInt.self), UInt?: \(type(of: optionalUnsigned))")
		//float, class java.lang.Float
		print("Float: \(Float.self), Float?: \(type(of: optionalFloat))")
		//double, class java.lang.Double
		print("Double: \(Double.self), Double?: \(type(of: optionalDouble))")
	}
	
	public func testConversions(){
		
		//pass numbers inside initilizers to perform the conversion
		let someDouble = Double(14)
		let someInt = Int(UInt16.max)
		
		//WARNING: while overflow will result in runtime except in swift
		//in silver, no overflow check will occur and
		//this will silently result in truncation that will yield 1
		#if COOPER
			let byte = Int8(257.0)
			print("Result after Int8(257.0) overflow: \(byte)")
		#endif
		
		let parsedNumberº = "38.0".doubleRepresentation
		let parsedNaNº = "not-a-number".integerRepresentation
		print("Parsed number: \(parsedNumberº)")
		print("Parsed NaN: \(parsedNaNº)")	 
	}
}
