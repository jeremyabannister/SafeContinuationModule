//
//  SafeContinuation.swift
//  
//
//  Created by Jeremy Bannister on 9/6/22.
//

///
@available(iOS 13.0, macOS 10.15.0, watchOS 6.0.0, tvOS 13.0.0, *)
public func withSafeCheckedContinuation
    <T>
    (named name: String = "<#unnamed#>",
     _ body: (SafeContinuation<T, Never>)->())
async -> T {
    await withCheckedContinuation { unsafeContinuation in
        body(
            SafeContinuation(
                name: name,
                unsafeContinuation: unsafeContinuation
            )
        )
    }
}

///
@available(iOS 13.0, macOS 10.15.0, watchOS 6.0.0, tvOS 13.0.0, *)
public func withSafeCheckedThrowingContinuation
    <T>
    (named name: String = "<#unnamed#>",
     _ body: (SafeContinuation<T, Error>)->())
async throws -> T {
    try await withCheckedThrowingContinuation { unsafeContinuation in
        body(
            SafeContinuation(
                name: name,
                unsafeContinuation: unsafeContinuation
            )
        )
    }
}

///
@available(iOS 13.0, macOS 10.15.0, watchOS 6.0.0, tvOS 13.0.0, *)
public actor SafeContinuation <Output, Failure: Error> {
    
    ///
    public init
        (name: String,
         unsafeContinuation: CheckedContinuation<Output, Failure>) {
        
        ///
        self.name = name
        self.unsafeContinuation = unsafeContinuation
    }
    
    ///
    private let name: String
    private let unsafeContinuation: CheckedContinuation<Output, Failure>
    private var hasResumed: Bool = false
    
    ///
    public nonisolated func resume (returning output: Output) {
        resume(with: .success(output))
    }
    
    ///
    public nonisolated func resume (throwing error: Failure) {
        resume(with: .failure(error))
    }
    
    ///
    public nonisolated func resume (with result: Result<Output, Failure>) {
        Task { await self._resume(with: result) }
    }
    
    ///
    private func _resume (with result: Result<Output, Failure>) {
        guard !hasResumed else { return }
        hasResumed = true
        unsafeContinuation.resume(with: result)
    }
    
    ///
    deinit {
        if !hasResumed {
            print("SafeContinuation(\(name)) has leaked.")
        }
    }
}
