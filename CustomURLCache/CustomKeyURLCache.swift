import Foundation

/// Cache with custom URL rewrite policies.
/// Use this to remap ephemeral URLs (e.g. signed URLs) into stable URLs.
class CustomKeyURLCache: URLCache, @unchecked Sendable {
    private let key: (_ url: URLRequest) -> URLRequest

    static func Identity(_ r: URLRequest) -> URLRequest { return r }

    static func Path(_ r: URLRequest) -> URLRequest {
        guard let url = r.url else { return r }

        var req = URLRequest(url: CustomKeyURLCache.Path(url), cachePolicy: r.cachePolicy, timeoutInterval: r.timeoutInterval)
        req.httpMethod = r.httpMethod

        return req
    }

    static func Path(_ url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }

        components.query = nil
        components.fragment = nil

        return components.url ?? url
    }

    init(memoryCapacity: Int, diskCapacity: Int, diskPath: String? = nil, key: @escaping (_ url: URLRequest) -> URLRequest = CustomKeyURLCache.Identity) {
        self.key = key
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
    }

    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        return super.cachedResponse(for: key(request))
    }

    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        super.storeCachedResponse(cachedResponse, for: key(request))
    }

    override func removeCachedResponse(for request: URLRequest) {
        super.removeCachedResponse(for: key(request))
    }
}
