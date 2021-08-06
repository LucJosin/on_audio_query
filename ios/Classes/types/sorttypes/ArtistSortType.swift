import MediaPlayer

public func checkArtistSortType(sortType: Int) -> MPMediaGrouping {
    switch sortType {
    case 1:
        return MPMediaGrouping.artist
    default:
        return MPMediaGrouping.artist
    }
}
