platform :ios, '9.0'

target 'SandboxApp' do
    use_frameworks!

    pod 'PowerAuth2',           :git => 'https://github.com/lime-company/lime-security-powerauth-mobile-sdk.git', :commit => '887729f45a06bc99cbe9cfc4908e71529bbd1314', :submodules => true
    pod 'LimeAuth/UIResources', :git => 'https://github.com/lime-company/swift-lime-auth.git', :commit => '8eeb37e3100e6827ffd8447b619fab195c0b51bd'
	pod 'LimeCore',				:git => 'https://github.com/lime-company/swift-lime-core.git', :commit => 'e53132b217db7832e0e68f6bf4d759a60485a25b'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['ENABLE_BITCODE'] = 'NO'
		end
	end
end