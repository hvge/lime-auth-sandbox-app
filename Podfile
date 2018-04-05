platform :ios, '9.0'

target 'SandboxApp' do
    use_frameworks!

    pod 'PowerAuth2',           :git => 'https://github.com/lime-company/lime-security-powerauth-mobile-sdk.git', :commit => '861f8cb10a5ab3b51349ddcae08ccca8d2a6255a', :submodules => true
	pod 'LimeCore'
	pod 'LimeAuth/UIResources', :git => 'https://github.com/lime-company/swift-lime-auth.git', :commit => '59d208139b595aa907aafa6e23d1d89f2d6cf760'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['ENABLE_BITCODE'] = 'NO'
		end
	end
end
