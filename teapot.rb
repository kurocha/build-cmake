
teapot_version "3.0"

define_target "build-cmake" do |target|
	target.depends "Build/Make"
	
	target.provides "Build/CMake" do
		define Rule, "cmake.unix-makefiles" do
			input :source
			
			parameter :install_prefix
			
			# Arguments to provide to cmake:
			parameter :arguments, optional: true
			
			# Ensure that incoming libraries are dependencies of this target:
			input :dependencies, implicit: true do |arguments|
				environment[:linkflags]&.select{|option| option.kind_of? Files::Path}
			end
			
			parameter :build_prefix, implicit: true do |arguments|
				Path.join(arguments[:install_prefix], "build")
			end
			
			output :package_files
			
			apply do |arguments|
				install_prefix = arguments[:install_prefix]
				build_prefix = arguments[:build_prefix]
				
				mkpath install_prefix
				mkpath build_prefix
				
				run!("cmake", "-G", "Unix Makefiles",
					"-DCMAKE_INSTALL_PREFIX:PATH=#{install_prefix}",
					"-DCMAKE_PREFIX_PATH=#{build_prefix}",
					# On some systems this gets set to lib64 or something equally useless.
					"-DCMAKE_INSTALL_LIBDIR=lib",
					*arguments[:arguments],
					arguments[:source],
					chdir: build_prefix
				)
				
				make prefix: build_prefix, package_files: arguments[:package_files]
			end
		end
	end
end

define_configuration 'cmake' do |configuration|
	configuration.require "build-make"
end
