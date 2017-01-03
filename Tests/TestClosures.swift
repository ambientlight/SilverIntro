//
//  TestClosures.swift
//  SilverIntro
//
//  Created by Taras Vozniuk on 20/12/2016.
//  Copyright © 2016 Ambientlight. All rights reserved.
//

#if COOPER
    import remobjects.elements.eunit
    
    //Handler, Looper
    import android.os
    //Executors, CountDownLatch, Semaphore, ThreadPoolExecutor
    import java.util.concurrent
    //Date
    import java.util
#else
    import XCTest
    
    import Dispatch
#endif

public class TestClosures: Test {
    
    //@escaping is not allowed to use with closure parameters in declarations
    #if COOPER
        var closureWithEscapingClosureAsParameterº: ( ((String) -> Void) -> Void)?
    #else
        var closureWithEscapingClosureAsParameterº: ( (@escaping (String) -> Void) -> Void)?
    #endif
    
    public func testSomeAsynchCode(){
        
        //asynchronous code on main thread
        #if COOPER
            Handler(Looper.getMainLooper()).post {
                //all EUnit tests execute on the main thread in a single runloop
                //this will be then called after all tests finish
                print("Some stuff after all tests finish")
            }
        #else
            DispatchQueue.main.async {
                //same here: all tests are executed on the main thread
                //and the process terminates once tests are done
                print("This will never be executed")
            }
        #endif
        
        //some asynchronous code on another thread
        //this thread waits for completion with timeout
        #if COOPER
            
            let serialQueue = Executors.newSingleThreadExecutor()
            let awaitEntity = CountDownLatch(1)
            
            serialQueue.execute {
                print("some asynch code to play with")
                awaitEntity.countDown()
            }
            awaitEntity.await(10, TimeUnit.SECONDS)
            
            //same thing can be also done with Semaphores
            let semaphore = Semaphore(0)
            serialQueue.execute {
                print("some more asynch code to play with")
                semaphore.release()
            }
            semaphore.acquire()
            
        #else
            
            let serialQueue = DispatchQueue(label: "silverintro.test-queue")
            let awaitEntity = self.expectation(description: "Let's wait until the next asynch code completes")
            
            serialQueue.async {
                print("some asynch code to play with")
                awaitEntity.fulfill()
            }
            self.waitForExpectations(timeout: 10.0, handler: nil)
            
            //same thing can be also done with Semaphores
            let semaphore = DispatchSemaphore(value: 0)
            serialQueue.async {
                print("some more asynch code to play with")
                semaphore.signal()
            }
            semaphore.wait()
            
        #endif
        
        //concurrent thread queues with fixed simultaneous concurrent threads
        let threadCount = 3
        #if COOPER
            //corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue
            let concurrentQueue = ThreadPoolExecutor(threadCount, threadCount, 10, TimeUnit.SECONDS, LinkedBlockingDeque<Runnable>())
        #else
            let concurrentQueue = OperationQueue()
            concurrentQueue.maxConcurrentOperationCount = threadCount
        #endif
        
        let secondsForThreadToSleep = 1
        for _ in 0 ..< threadCount {
            #if COOPER
                concurrentQueue.execute {
                    Thread.sleep(secondsForThreadToSleep * 1000)
                    print("yawn... \(Date())")
                }
            #else
                concurrentQueue.addOperation {
                    sleep(UInt32(secondsForThreadToSleep))
                    print("yawn... \(Date())")
                }
            #endif
        }
        
        #if COOPER
            Thread.sleep(2 * 1000)
        #else
            sleep(2)
        #endif
        
        print("This should be printed after all thread yawned")
    }
}
