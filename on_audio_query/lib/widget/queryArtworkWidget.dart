/*
=============
Author: Lucas Josino
Github: https://github.com/LucasPJS
Website: https://lucasjosino.com/
=============
Plugin/Id: on_audio_query#0
Homepage: https://github.com/LucasPJS/on_audio_query
Pub: https://pub.dev/packages/on_audio_query
License: https://github.com/LucasPJS/on_audio_query/blob/main/LICENSE
Copyright: © 2021, Lucas Josino. All rights reserved.
=============
*/

part of on_audio_query;

/// Widget that will help to "query" artwork for song/album.
///
/// A simple example on how you can use the [queryArtwork].
///
/// See more: [QueryArtworkWidget](https://shorturl.at/rBR68)
class QueryArtworkWidget extends StatelessWidget {
  /// Used to find and get image.
  ///
  /// All Audio/Song has a unique [id].
  final int id;

  /// Used to define artwork [type].
  ///
  /// Opts: [AUDIO] and [ALBUM].
  final ArtworkType type;

  /// Deprecated after [2.0.0].
  final String? artwork;

  /// Deprecated after [2.0.0].
  final int? deviceSDK;

  /// Used to define artwork [format].
  ///
  /// Opts: [JPEG] and [PNG].
  ///
  /// Important:
  ///
  /// * If [format] is null, will be set to [JPEG].
  final ArtworkFormat? format;

  /// Used to define artwork [size].
  ///
  /// Important:
  ///
  /// * If [size] is null, will be set to [200].
  /// * This value have a directly influence to image quality.
  final int? size;

  /// Deprecated after [2.0.0].
  final bool? requestPermission;

  /// Used to define the artwork [border radius].
  ///
  /// Important:
  ///
  /// * If [artworkBorder] is null, will be set to [50].
  final BorderRadius? artworkBorder;

  /// Used to define the artwork [quality].
  ///
  /// Important:
  ///
  /// * If [artworkQuality] is null, will be set to [low].
  /// * This value [don't] have a directly influence to image quality.
  final FilterQuality? artworkQuality;

  /// Used to define artwork [width].
  ///
  /// Important:
  ///
  /// * If [artworkWidth] is null, will be set to [50].
  final double? artworkWidth;

  /// Used to define artwork [height].
  ///
  /// Important:
  ///
  /// * If [artworkHeight] is null, will be set to [50].
  final double? artworkHeight;

  /// Used to define artwork [fit].
  ///
  /// Important:
  ///
  /// * If [artworkFit] is null, will be set to [cover].
  final BoxFit? artworkFit;

  /// Used to define artwork [clip].
  ///
  /// Important:
  ///
  /// * If [artworkClipBehavior] is null, will be set to [antiAlias].
  final Clip? artworkClipBehavior;

  /// Used to define artwork [scale].
  ///
  /// Important:
  ///
  /// * If [artworkScale] is null, will be set to [1.0].
  final double? artworkScale;

  /// Used to define if artwork should [repeat].
  ///
  /// Important:
  ///
  /// * If [artworkRepeat] is null, will be set to [false].
  final ImageRepeat? artworkRepeat;

  /// Used to define artwork [color].
  ///
  /// Important:
  ///
  /// * [artworkColor] default value is [null].
  final Color? artworkColor;

  /// Used to define artwork [blend].
  ///
  /// Important:
  ///
  /// * [artworkBlendMode] default value is [null].
  final BlendMode? artworkBlendMode;

  /// Used to define if artwork should [keep] old art even when [Flutter State] change.
  ///
  /// ## Flutter Docs:
  ///
  /// ### Why is the default value of [gaplessPlayback] false?
  ///
  /// Having the default value of [gaplessPlayback] be false helps prevent
  /// situations where stale or misleading information might be presented.
  /// Consider the following case:
  ///
  /// We have constructed a 'Person' widget that displays an avatar [Image] of
  /// the currently loaded person along with their name. We could request for a
  /// new person to be loaded into the widget at any time. Suppose we have a
  /// person currently loaded and the widget loads a new person. What happens
  /// if the [Image] fails to load?
  ///
  /// * Option A ([gaplessPlayback] = false): The new person's name is coupled
  /// with a blank image.
  ///
  /// * Option B ([gaplessPlayback] = true): The widget displays the avatar of
  /// the previous person and the name of the newly loaded person.
  ///
  /// Important:
  ///
  /// * If [keepOldArtwork] is null, will be set to [false].
  final bool? keepOldArtwork;

  /// Used to define a Widget when audio/song don't return any artwork.
  ///
  /// Important:
  ///
  /// * If [nullArtworkWidget] is null, will be set to [image_not_supported] icon.
  final Widget? nullArtworkWidget;

  /// Widget that will help to "query" artwork for song/album.
  ///
  /// A simple example on how you can use the [queryArtwork].
  ///
  /// See more: [QueryArtworkWidget](https://shorturl.at/rBR68)
  const QueryArtworkWidget(
      {Key? key,
      required this.id,
      required this.type,
      @Deprecated("This method will be removed soon") this.artwork,
      @Deprecated("This method will be removed soon") this.deviceSDK,
      this.format,
      this.size,
      @Deprecated("This method will be removed soon") this.requestPermission,
      this.artworkQuality,
      this.artworkBorder,
      this.artworkWidth,
      this.artworkHeight,
      this.artworkFit,
      this.artworkClipBehavior,
      this.artworkScale,
      this.artworkRepeat,
      this.artworkColor,
      this.artworkBlendMode,
      this.keepOldArtwork,
      this.nullArtworkWidget});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: OnAudioQuery().queryArtwork(
        id,
        type,
        format: format ?? ArtworkFormat.JPEG,
        size: size ?? 200,
      ),
      builder: (context, item) {
        if (item.data != null && item.data!.isNotEmpty) {
          return ClipRRect(
            borderRadius: artworkBorder ?? BorderRadius.circular(50),
            clipBehavior: artworkClipBehavior ?? Clip.antiAlias,
            child: Image.memory(
              item.data!,
              gaplessPlayback: keepOldArtwork ?? false,
              repeat: artworkRepeat ?? ImageRepeat.noRepeat,
              scale: artworkScale ?? 1.0,
              width: artworkWidth ?? 50,
              height: artworkHeight ?? 50,
              fit: artworkFit ?? BoxFit.cover,
              color: artworkColor,
              colorBlendMode: artworkBlendMode,
              filterQuality: artworkQuality ?? FilterQuality.low,
            ),
          );
        }
        return nullArtworkWidget ??
            Icon(
              Icons.image_not_supported,
              size: 50,
            );
      },
    );
  }
}
