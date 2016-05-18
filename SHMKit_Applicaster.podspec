Pod::Spec.new do |s|
  s.name         = "SHMKit_Applicaster"
  s.version      = "0.1.2"
  s.summary      = "A generic client for Siren Hypermedia APIs",
  s.homepage     = "https://github.com/mdobson/SHMKit"
  s.license      = 'MIT'
  s.authors      = {"Matt Dobson" => "mdobson4@gmail.com"}
  s.source       = { :git => "https://github.com/mdobson/SHMKit.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = 'Pod/Classes/**/*.{h,m}'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.exclude_files = 'ApplicasterSDK/**/non-arc/*','**/*Tests.m'
  s.requires_arc = true
  s.resources = [
      'Pod/Assets/*.png'
    ]
end
