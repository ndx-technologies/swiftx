import Foundation

class StatsCustomKeyURLCache: CustomKeyURLCache, @unchecked Sendable {
    private var hitCount: Int = 0
    private var missCount: Int = 0
    private let lock = NSLock()

    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let v = super.cachedResponse(for: request)

        lock.lock()
        if v == nil {
            missCount += 1
        }
        else {
            hitCount += 1
        }
        lock.unlock()

        return v
    }

    func HitCount() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return hitCount
    }

    func MissCount() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return missCount
    }
}
