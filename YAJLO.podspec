Pod::Spec.new do |s|
  s.name         = "YAJLO"
  s.version      = "0.3.4"
  s.summary      = "Objective-C bindings for YAJL (Yet Another JSON Library) C library"
  s.homepage     = "http://lloyd.github.com/yajl"
  s.license      = 'MIT'
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com", "David Hart" => "david@hartbit.com" }
  s.source       = { :git => "https://github.com/gabriel/yajl-objc.git", :tag => s.version.to_s }
  s.source_files = 'Classes/*.{h,m}', 'yajl-2.1.0/*.{h,c}', 'yajl-2.1.0/api/*.h'
  s.public_header_files = 'Classes/*.h'
  s.requires_arc = true
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
end
