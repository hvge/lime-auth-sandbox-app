platform :ios, '9.0'

target 'SandboxApp' do
    use_frameworks!

    pod 'PowerAuth2',           :git => 'https://github.com/lime-company/lime-security-powerauth-mobile-sdk.git', :commit => '887729f45a06bc99cbe9cfc4908e71529bbd1314', :submodules => true
	pod 'LimeCore',				:git => 'https://github.com/lime-company/swift-lime-core.git', :commit => 'e53132b217db7832e0e68f6bf4d759a60485a25b'
	pod 'LimeAuth/UIResources', :git => 'https://github.com/lime-company/swift-lime-auth.git', :commit => 'a1d597d0efe1b6abad6477dfb697dbf61f82a3f8'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['ENABLE_BITCODE'] = 'NO'
		end
	end
end
