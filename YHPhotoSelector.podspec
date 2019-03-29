Pod::Spec.new do |s|
s.name             = 'YHPhotoSelector'
s.version          = '0.0.3'
s.swift_version = '4.2'
s.summary          = '相册和视频选择器'
s.homepage         = 'https://github.com/YangHaoLoad/YHPhotoSelectorDemo'
s.license          = 'MIT'
s.author           = { 'YangHao' => '327737175@qq.com' }
s.source           = { :git => 'https://github.com/YangHaoLoad/YHPhotoSelectorDemo.git', :tag => s.version }
s.platform     = :ios, '10.0'
s.source_files = 'YHPhotoSelectorDemo/YHPhotoSelector/*'
s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end