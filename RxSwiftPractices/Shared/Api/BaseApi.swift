//
//  BaseApi.swift
//  RxSwiftPractices
//
//  Created by Adriano Song on 4/2/20.
//  

//import Foundation
//import Alamofire
//import RxSwift
//
//enum AlamoError: Error {
//    case invalidURL
//    case badRequest (description: String)
//    case notFound
//    case forbidden
//    case unknown
//}
//
//class BaseApi {
//
//    static func request<T: Codable>(urlConvertile: URLRequestConvertible) -> Observable<T> {
//
//        return Observable<T>.create { emitter in
//            let request = AF.request(urlConvertile).responseData(completionHandler: { data in
//
//                switch data.response?.statusCode {
//                case 200:
//                    switch data.result {
//                    case .success(let dataValue):
//
//                        printSuccessData(data: dataValue)
//
//                        do {
//                            let decoder = JSONDecoder()
//                            let parsedDataToModel = try decoder.decode(T.self, from: dataValue)
//
//                            emitter.onNext(parsedDataToModel)
//                            emitter.onCompleted()
//
//                        } catch let error {
//                            emitter.onError(error)
//                        }
//                    case .failure(let error):
//                        emitter.onError(error)
//                    }
//
//                case 400:
//                    emitter.onError(AlamoError.badRequest(
//                        description: data.response?.allHeaderFields[AnyHashable("X-Exit")] as? String ?? ""))
//                case 403:
//                    emitter.onError(AlamoError.forbidden)
//                case 404:
//                    emitter.onError(AlamoError.notFound)
//                default:
//                    emitter.onError(AlamoError.unknown)
//                }
//            })
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }
//
//    static func printSuccessData(data: Data) {
//        #if DEBUG
//            let successString = String(decoding: data, as: UTF8.self)
//            print("Success data returned \(successString)")
//        #endif
//    }
//}
