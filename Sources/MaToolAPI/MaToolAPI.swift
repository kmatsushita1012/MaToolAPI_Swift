// The Swift Programming Language
// https://docs.swift.org/swift-book

import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

@main
struct MaToolAPI {
    static func main() async throws {
        do {
            let runtime = LambdaRuntime { (request: APIGatewayV2Request, context: LambdaContext) in
                try await self.handler(request: request, context: context)
            }
            try await runtime.run()
        } catch {
            print("LambdaRuntime crashed: \(error)")
            throw error
        }
    }

    static func handler(request: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response {
        let path = request.rawPath
        let method = request.context.http.method.rawValue

        // ルーティング: GET /name/{name}
        if method == "GET", path.hasPrefix("/name/") {
            let name = String(path.dropFirst("/name/".count))
            let responseBody: [String: String] = ["name": name]
            let data = try JSONEncoder().encode(responseBody)
            let bodyString = String(data: data, encoding: .utf8)!

            return APIGatewayV2Response(
                statusCode: .ok,
                headers: ["Content-Type": "application/json"],
                body: bodyString
            )
        } else if method == "GET" {
            return APIGatewayV2Response(
                statusCode: .ok,
                headers: ["Content-Type": "application/json"],
                body: #"{"message": "Hello World"}"#
            )
        } else {
            return APIGatewayV2Response(
                statusCode: .notFound,
                headers: ["Content-Type": "application/json"],
                body: #"{"error": "Not Found"}"#
            )
        }
    }
}
