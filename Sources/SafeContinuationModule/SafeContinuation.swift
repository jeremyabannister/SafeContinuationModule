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
    (_ body: (SafeContinuation<T, Never>)->())
async -> T {
    await withCheckedContinuation { unsafeContinuation in
        body(SafeContinuation(unsafeContinuation))
    }
}

///
@available(iOS 13.0, macOS 10.15.0, watchOS 6.0.0, tvOS 13.0.0, *)
public func withSafeCheckedThrowingContinuation
    <T>
    (_ body: (SafeContinuation<T, Error>)->())
async throws -> T {
    try await withCheckedThrowingContinuation { unsafeContinuation in
        body(SafeContinuation(unsafeContinuation))
    }
}

///
@available(iOS 13.0, macOS 10.15.0, watchOS 6.0.0, tvOS 13.0.0, *)
public actor SafeContinuation <Output, Failure: Error> {
    
    ///
    public init (_ continuation: CheckedContinuation<Output, Failure>) {
        self.continuation = continuation
    }
    
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
    private let continuation: CheckedContinuation<Output, Failure>
    private var hasResumed: Bool = false
    
    ///
    private func _resume (with result: Result<Output, Failure>) {
        guard !hasResumed else { return }
        hasResumed = true
        continuation.resume(with: result)
    }
}
