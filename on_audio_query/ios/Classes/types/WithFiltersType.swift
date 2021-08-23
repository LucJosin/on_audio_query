import MediaPlayer

func checkSongsArgs(args: Int, argsVal: String) -> MPMediaPropertyPredicate {
    var filter: MPMediaPropertyPredicate? = nil
    switch args {
    case 0:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains)
    case 1:
        print("[on_audio_warning] - IOS don't support [DISPLAY_NAME] type, will be used as [TITLE]")
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyTitle)
    case 2:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyAlbumTitle)
    case 3:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyArtist)
    default:
        break
    }
    return filter!
}

func checkAlbumsArgs(args: Int, argsVal: String) -> MPMediaPropertyPredicate {
    var filter: MPMediaPropertyPredicate? = nil
    switch args {
    case 0:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyAlbumTitle)
    case 1:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyAlbumArtist)
    default:
        break
    }
    return filter!
}

//Playlist

func checkArtistsArgs(args: Int, argsVal: String) -> MPMediaPropertyPredicate {
    var filter: MPMediaPropertyPredicate? = nil
    switch args {
    case 0:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyArtist)
    default:
        break
    }
    return filter!
}

func checkGenresArgs(args: Int, argsVal: String) -> MPMediaPropertyPredicate {
    var filter: MPMediaPropertyPredicate? = nil
    switch args {
    case 0:
        filter = MPMediaPropertyPredicate.init(value: argsVal, forProperty: MPMediaItemPropertyGenre)
    default:
        break
    }
    return filter!
}
