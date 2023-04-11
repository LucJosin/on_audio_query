# on_audio_query_web

A web implementation of [`on_audio_query`](https://pub.dev/packages/on_audio_query) plugin.

## Limitations on the web platform:

Since Web Browsers **don't** offer direct access to their user's `file system`, this plugin will use the `assets` folder to "query" the audios files. So, will totally depend of the `developer`.

## Setup:

After installing the [`on_audio_query`](https://pub.dev/packages/on_audio_query) plugin, define the `path` inside the `pubspec.yml`:

```yaml
  # You don't need add every audio file path, just define the folder.
  assets:
    - assets/
    # If your files are in another folder inside the `assets`:
    - assets/audios/
    # - assets/audios/animals/
    # - assets/audios/animals/cat/
    # ...
```



