Pod::Spec.new do |s|
  s.name         = "yajl-objc"
  s.version      = "0.3.0"
  s.summary      = "Objective-C bindings for YAJL (Yet Another JSON Library) C library"
  s.homepage     = "http://lloyd.github.com/yajl"
  s.license      = 'MIT'
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com", "David Hart" => "david@hartbit.com" }
  s.source       = { :git => "https://github.com/hartbit/yajl-objc.git", :branch => "master" }
  s.source_files = 'Classes/*.{h,m}', 'yajl-1.0.11/*.{h,m}', 'yajl-1.0.11/api/*.h'
  s.public_header_files = 'yajl-1.0.11/api/*.h'
  s.dependency     'yajl', '~>1.0.11'
  s.requires_arc = true
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
end
