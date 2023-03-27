enum NetworkConstants {
    static let ip = "95.163.211.116"

    private static let port = "8155"
    private static let baseUrl = "http://\(ip):\(port)"

    enum Route {

        enum Film {
            private static let base = baseUrl + "/Films"

            static let uploadTrailer = base + "/DownloadVideo"
            static let uploadModel = base + "/CreateFilm"
            static let searchFilms = base + "/SearchFilms"
        }

        enum Countries {
            private static let base = baseUrl + "/Countries"

            static let getCountries = base + "/GetCountries"
        }
        
        enum FilmTypes {
            private static let base = baseUrl + "/FilmTypes"
            
            static let getFilmTypes = base + "/FilmTypes"
        }
        
        enum Actors {
            static let getActors = baseUrl + "/GetActors"
        }

    }

}
