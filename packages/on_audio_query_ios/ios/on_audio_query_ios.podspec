#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint on_audio_query.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'on_audio_query_ios'
  s.version          = '0.0.1'
  s.summary          = 'on_audio_query flutter plugin for ios.'
  s.description      = <<-DESC
  Flutter Plugin used to query audios/songs infos [title, artist, album, etc..] from device storage.
                       DESC
  s.homepage         = 'https://github.com/LucJosin/on_audio_query'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Lucas Josino' => 'contact@lucasjosino.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SwiftyBeaver'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
