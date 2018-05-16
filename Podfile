platform :ios, '9.0'

target 'SandboxApp' do
    use_frameworks!

    pod 'PowerAuth2'
	pod 'LimeCore'
	pod 'LimeAuth/UIResources'
	pod 'LimeAuth/UIResources_Images'
	pod 'LimeAuth/UIResources_Illustrations'

	#pod 'LimeAuth/UIResources', :path => '~/Dev/lime/swift/swift-lime-auth'
	#pod 'LimeAuth/UIResources_Images', :path => '~/Dev/lime/swift/swift-lime-auth'
	#pod 'LimeAuth/UIResources_Illustrations', :path => '~/Dev/lime/swift/swift-lime-auth'
	
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['ENABLE_BITCODE'] = 'NO'
		end
	end
end
