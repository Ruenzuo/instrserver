Pod::Spec.new do |s|
  s.name             = 'instrserver'
  s.version          = '0.1.0'
  s.summary          = 'HTTP server component for instr'
  s.description      = <<-DESC
HTTP server component for instr
                       DESC
  s.homepage         = 'https://github.com/ruenzuo/instrserver'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ruenzuo' => 'renzo.crisostomo@me.com' }
  s.source           = { :git => 'https://github.com/ruenzuo/instrserver.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'instrserver/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation'
  s.libraries = 'objc'
  s.dependency 'GCDWebServer', '~> 3.4'
  s.pod_target_xcconfig = { 'ENABLE_STRICT_OBJC_MSGSEND' => 'NO' }
end
