
teapot_version "1.0.0"

define_target "build-cmake" do |target|
	target.provides "Build/CMake" do
		define Rule, "cmake.unix-makefiles" do
			input :source
			
			parameter :build_prefix
			
			output :make_file, implicit: true do |arguments|
				Path.join(arguments[:build_prefix], "Makefile")
			end
			
			apply do |arguments|
				fs.mkpath arguments[:build_prefix]
				
				run!("cmake", "-G", "Unix Makefiles",
					"-DCMAKE_INSTALL_PREFIX:PATH=#{environment[:install_prefix]}",
					"-DCMAKE_PREFIX_PATH=#{environment[:install_prefix]}",
					arguments[:source],
					chdir: arguments[:build_prefix]
				)
			end
		end
	end
end
