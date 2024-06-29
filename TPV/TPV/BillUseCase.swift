//
//  BillUseCase.swift
//  TPV
//
//  Created by Pablo Ceacero on 24/6/24.
//

import Foundation

final class NetworkClient {

    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidRequest
        case invalidResponse
        case decodingError(Error)
        case unknownError
    }

    let url = "http://localhost:8080"
    let headers: [String: String] = [
        "Content-Type": "application/json"
    ]

    func getBills() async throws -> [BillDTO.BuilderResponse] {
        guard let url = URL(string: url + "/bills") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach({ request.setValue($1, forHTTPHeaderField: $0) })

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            do {
                return try JSONDecoder().decode([BillDTO.BuilderResponse].self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    func postBill(billName: String) async throws -> BillDTO.BuilderResponse {
        guard let url = URL(string: url + "/bills") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach({ request.setValue($1, forHTTPHeaderField: $0) })

        let body: [String: Any] = [
            "name": billName
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            throw NetworkError.invalidRequest
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            do {
                return try JSONDecoder().decode(BillDTO.BuilderResponse.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    func patchBill(billId: String, bill: BillDTO.BuilderRequest) async throws -> BillDTO.BuilderResponse {
        guard let url = URL(string: url + "/bills/\(billId)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        headers.forEach({ request.setValue($1, forHTTPHeaderField: $0) })

        guard let jsonData = try? JSONEncoder().encode(bill) else {
            throw NetworkError.invalidRequest
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            do {
                return try JSONDecoder().decode(BillDTO.BuilderResponse.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

final class BillUseCase {

    enum BillUseCaseError: Error{
        case networkError(NetworkClient.NetworkError)
    }

    func getBills() async throws -> [Bill] {
        do {
            return try await NetworkClient().getBills().map { $0.toEntity() }
        } catch let error as NetworkClient.NetworkError {
            throw BillUseCaseError.networkError(error)
        }
    }

    func postBill(billName: String) async throws -> Bill {
        do {
            return try await NetworkClient().postBill(billName: billName).toEntity()
        } catch let error as NetworkClient.NetworkError {
            throw BillUseCaseError.networkError(error)
        }
    }

    func patchBill(bill: Bill) async throws -> Bill {
        do {
            let bill = try await NetworkClient().patchBill(billId: bill.id.uuidString,
                                                           bill: bill.toDTORequest())
            return bill.toEntity()
        } catch let error as NetworkClient.NetworkError {
            throw BillUseCaseError.networkError(error)
        }
    }
}
