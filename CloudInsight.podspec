Pod::Spec.new do |s|
  s.name = 'CloudInsight'
  s.version = '0.1.7'
  s.license = 'Apache 2'
  s.summary = 'Light analytics on top of CloudKit'
  s.homepage = 'https://github.com/coodly/CloudInsight'
  s.authors = { 'Jaanus Siim' => 'jaanus@coodly.com' }
  s.source = { :git => 'git@github.com:coodly/CloudInsight.git', :tag => s.version }
  s.default_subspec = 'Client'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '10.0'
  #s.osx.deployment_target = '10.11'

  s.subspec 'Core' do |core|
    core.source_files = 'Source/Core/*.swift'
    core.dependency 'CoreDataPersistence', '0.2.3'
    core.dependency 'Puff/Core', '0.6.2'
    core.dependency 'Puff/CoreData', '0.6.2'
    core.dependency 'KeychainAccess', '4.2.1'
    
    core.resource_bundle = {'CloudInsight' => 'Source/Core/CloudInsight.xcdatamodeld'}
  end
  
  s.subspec 'Client' do |client|
    client.source_files = 'Source/Client'
    client.dependency 'CloudInsight/Core'
  end
  
  s.subspec 'Reporting' do |rep|
    rep.ios.deployment_target = '13.1'
    rep.source_files = 'Source/Reporting'
    rep.dependency 'CloudInsight/Core'
  end

  #s.subspec 'Admin' do |admin|
  #  admin.source_files = "Source/Admin"
  #  admin.dependency "CloudFeedback/Core"
  #end
  
  #s.subspec 'iOS' do |ios|
  #    ios.source_files = "Source/iOS"
  #    ios.dependency "CloudFeedback/Core"
  #end


  #s.source_files = 'Sources/*.swift'
  #s.tvos.exclude_files = ['Sources/ShakeWindow.swift']
  #s.osx.exclude_files = ['Sources/ShakeWindow.swift']

  s.requires_arc = true
end
