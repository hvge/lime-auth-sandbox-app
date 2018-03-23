platform :ios, '9.0'

target 'SandboxApp' do
    use_frameworks!

    pod 'PowerAuth2',           :git => 'https://github.com/lime-company/lime-security-powerauth-mobile-sdk.git', :commit => '887729f45a06bc99cbe9cfc4908e71529bbd1314', :submodules => true
	pod 'LimeCore'
	pod 'LimeAuth/UIResources', :git => 'https://github.com/lime-company/swift-lime-auth.git', :commit => 'cf760911ccd8b34032f34aed76cc938b2613b56f'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['ENABLE_BITCODE'] = 'NO'
		end
	end
end
