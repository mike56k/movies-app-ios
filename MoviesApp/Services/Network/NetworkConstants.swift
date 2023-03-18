enum NetworkConstants {
    static let ip = "10.56.3.181"

    private static let port = "7179"
    private static let baseUrl = "https://\(ip):\(port)"

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

    }

}
