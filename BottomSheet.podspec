Pod::Spec.new do |spec|
spec.name = "BottomSheet"
spec.version = "1.0.0"
spec.summary = "Sample framework from blog post, not for real world use."
spec.homepage = ""
spec.license = { type: 'MIT', file: 'LICENSE' }
spec.authors = { "Your Name" => 'avgoustis.george.mail@gmail.com' }
spec.social_media_url = ""

spec.platform = :ios, "9.1"
spec.requires_arc = true
spec.source = { git: "", tag: "v#{1.0.0}", submodules: false }
spec.source_files = "BottomSheet/**/*.{h,swift}"

end
