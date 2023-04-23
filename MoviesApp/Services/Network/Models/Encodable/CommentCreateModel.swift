struct CommentCreateModel: Encodable {
    let userId: Int
    let filmId: Int
    let text: String
    let stars: Int
}
