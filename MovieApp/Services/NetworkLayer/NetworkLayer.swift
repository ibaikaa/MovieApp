//
//  NetworkLayer.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import RxSwift
import Alamofire

/*
 Данный класс предоставляет сетевой слой для выполнения запросов к API серверу.
 Используется Alamofire и RxSwift для обработки сетевых запросов и ответов и содержит
 в себе методы, способные вызываться из любой части приложения и которые возвращают данные из API.
 */

final class NetworkLayer {
    /// Singleton
    static let shared = NetworkLayer()
    private init () { }
    
    /// Dispose bag для ARC
    private let diposeBag = DisposeBag()
    
    /**
     Метод для получения списка из 250 ТОП фильмов от IMDb.
     – Возвращает следующее: Наблюдаемый объект, который выдает объект MovieGroup в случае успешного получения ответа от запроса или ApiError (ошибку) в случае возникновения ошибки.
     */
    
    public func getMovieList() -> Observable<MovieGroup> {
        
        // Получение URL-ссылки для запроса из перечисления `ApiType`.
        guard let url = ApiType.getMovies.url else {
            // Если URl `nil`, возвращать соответсвующую ошибку для наблюдаемого объекта.
            return Observable.error(ApiError.invalidURL)
        }
        
        // Создание нового наблюдаемого свойства для отправки запроса
        return Observable<MovieGroup>.create { observer in
            // Создание и настройка запроса, используя `request` метод от Alamofire
            // и декодирование ответа в объект `MovieGroup`.
            let request = AF.request(
                url,
                method: ApiType.getMovies.method
            ).responseDecodable(of: MovieGroup.self) { response in
                // Отлавливание состояния ответа (успех/неудача)
                switch response.result {
                    // Если ответ успешный, возвращаем значение для `onNext`.
                case .success(let movieGroup):
                    observer.onNext(movieGroup)
                    observer.onCompleted()
                case .failure(let error):
                    // Если что-то пошло не так, через switch case попробуем определить ошибку и возвращаем ошибку.
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            // Возвращаем наблюдаемое свойство для остановки запроса.
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
    
    /**
     Метод для получения URL-ссылки на трейлер в YouTube в виде String.
     – Возвращает следующее: Наблюдаемый объект, который выдает объект MovieWithTrailer  в случае успешного получения ответа от запроса или ApiError (ошибку) в случае возникновения ошибки.
     */
    
    public func getMovieWithTrailer(id: String) -> Observable<MovieWithTrailer> {
        guard let url = ApiType.youtubeTrailerByID(id: id).url else {
            return Observable.error(ApiError.invalidURL)
        }
        print(url)
        return Observable<MovieWithTrailer>.create { observer in
            let request = AF.request(
                url,
                method: ApiType.youtubeTrailerByID(id: id).method
            ).responseDecodable(of: MovieWithTrailer.self) { response in
                switch response.result {
                case .success(let movie):
                    observer.onNext(movie)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
