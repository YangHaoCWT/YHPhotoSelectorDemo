Pod::Spec.new do |s|
s.name             = 'YHPhotoSelector'
s.version          = '0.1.5'
s.swift_version = '4.2'
s.summary          = '相册和视频选择器'
s.homepage         = 'https://github.com/YangHaoLoad/YHPhotoSelectorDemo'
s.license          = 'MIT'
s.author           = { 'YangHao' => '327737175@qq.com' }
s.source           = { :git => 'https://github.com/YangHaoLoad/YHPhotoSelectorDemo.git', :tag => s.version }
s.platform     = :ios, '12.1'
s.source_files = 'YHPhotoSelectorDemo/YHPhotoSelector/*'
s.resources    = 'YHPhotoSelectorDemo/YHPhotoSelector/*.{png,bundle}'
s.requires_arc = true
end
