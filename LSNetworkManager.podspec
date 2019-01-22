Pod::Spec.new do |s|

  s.name         = "LSNetworkManager"
  s.version      = "1.0.0"
  s.summary      = "基于AFNetwroking 3.0 封装的网络请求库"
  s.description  = %{
    基于AFNetwroking 3.0 封装的网络请求库, 使用灵活
  }
  s.homepage     = "https://github.com/SandroLiu/LSNetworkManager"
  s.license      = "MIT"
  s.author       = { "sandro" => "liushuai_ios@126.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/SandroLiu/LSNetworkManager.git", :tag => "#{s.version}" }
  s.source_files  = "LSNetworkManager/**/*.{h,m}"
  s.requires_arc = true
  s.dependency 'AFNetworking', '~>3.2.1'
end
