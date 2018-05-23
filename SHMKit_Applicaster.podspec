Pod::Spec.new do |s|
  s.name         = 'SHMKit_Applicaster'
  s.version      = '0.3.0'
  s.platform = :ios
	s.ios.deployment_target = "9.0"
  s.summary      = "A generic client for Siren Hypermedia APIs"
  s.homepage     = "https://github.com/mdobson/SHMKit"
  s.license      = 'MIT'
  s.authors      = "Matt Dobson"
  s.source       = {
                     :git => 'https://github.com/applicaster/SHMKit.git',
                     :tag => s.version.to_s
  }
  s.source_files = 'SHMKit/**/*.{h,m}'
  s.public_header_files = 'SHMKit/**/*.h'
  s.static_framework = true

end
