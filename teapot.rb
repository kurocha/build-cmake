
teapot_version "1.0.0"

define_target "build-cmake" do |target|
	target.provides "Build/CMake" do
		define "cmake.unix-makefiles", Rule do
			input :source
			
			parameter :build_prefix
			
			output :make_file, implicit: true do |arguments|
				FSO::Files::Paths.new(arguments[:build_prefix].full_path, "Makefile")
			end
			
			apply do |arguments|
				fs.mkpath arguments[:build_prefix].full_path
				
				run!("cmake", "-G", "Unix Makefiles",
					"-DCMAKE_INSTALL_PREFIX:PATH=#{environment[:install_prefix]}",
					"-DCMAKE_PREFIX_PATH=#{environment[:install_prefix]}",
					arguments[:source].full_path,
					chdir: arguments[:build_prefix].full_path
				)
			end
		end
	end
end
